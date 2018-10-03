#Create an alias for the container built from the node:alpine base image
FROM node:alpine as builder

#Setting the working directory inside the container to be the same name as our app on our local machine.
WORKDIR "/my-static-app"

#Copying our package.json file from our local machine to the working directory inside the docker container.
COPY package.json ./

#Installing the dependencies listed in our package.json file.
RUN npm install

#Copying our project files from our local machine to the working directory in our container.
COPY . .

#Create the production build version of the  react app
RUN npm run build

#Create a new container from a linux base image that has the aws-cli installed
FROM mesosphere/aws-cli

#Using the alias defined for the first container, copy the contents of the build folder to this container
COPY --from=builder /my-static-app/build .

#Set the default command of this container to push the files from the working directory of this container to our s3 bucket 
CMD ["s3", "sync", "./", "s3://static-serve-react-test"]   