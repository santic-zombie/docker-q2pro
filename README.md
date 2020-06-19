# docker-q2pro
Dockerfile for build q2proded container

How build:
```
docker build . --tag q2image
```

How run:
```
docker run --name q2 -d --rm -v /home/santic/.q2pro_t:/home/quake2/.q2pro -p 27999:27910/udp q2image +set game openffa +exec server.cfg

```
