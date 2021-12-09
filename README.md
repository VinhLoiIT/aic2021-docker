# aic2021-docker

Build command:
```
docker build -t aic:latest .
```

Run command:
```
docker run --rm -it -v test_data:/data/test_data:ro -v submission_output:/data/submission_output aic:latest /bin/bash run.sh
```
