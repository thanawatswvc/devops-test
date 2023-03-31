step (not completed)
1.Run Graphite
docker run -d\
 --name graphite\
 --restart=always\
 -p 80:80\
 -p 2003-2004:2003-2004\
 -p 2023-2024:2023-2024\
 -p 8125:8125/udp\
 -p 8126:8126\
 graphiteapp/graphite-statsd

2.Create Dockerfile
 cd to path that index.js, Dockerfile and package.json locate then run docker build -t nodestatsd .

3.Run ct
docker container run -p 8080:8080 -d --name nodejs-statsd nodestatsd

4.connect and create network 
docker network create nodeapp-statsd-Network && docker network connect nodeapp-statsd-Network graphite && docker network connect nodeapp-statsd-Network nodejs-statsd

5.graphite should work
http://localhost/


## Exercices

  1. Add a `Dockerfile` to containerize the app, with support for multiple environments (DEV, UAT & Production)
- I wish i can do this command work for handle each env by build "docker build   --build-arg BUILDTIME_NODE_ENV=staging -t node_helloworld ." but not yet finish


  2. Design the cloud infrastructure diagram (prefer AWS) with all the resources that are required for the application(Node app, `statsd` & the backend. Applicants can use any backends for `statsd` eg: `Graphite`)
- ![Diagram](https://user-images.githubusercontent.com/32988267/229088827-1ee66d59-b53d-42a9-a0c3-26fcbb22742d.png)

  3. Use Terraform to setup the infrastructure
- 
  4. (Optional) Deploy on the cloud computing platforms![Uploading Diagram.png…]()


## Submitting Your Code

Email us your Github repo and grant he access to `lycbrian` We expect meaningful git commits, ideally one commit per exercise with commit messages clearly communicating the intent.

If you deploy it to any cloud platforms, please send us instructions & relevant IAM user credentials.
