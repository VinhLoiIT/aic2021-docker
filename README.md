# aic2021-docker

Pull already built docker:
```
docker pull vinhloiit/aic2021:latest
```

Or build using command:
```
DOCKER_BUILDKIT=1 docker build --build-arg USERNAME=aic -t aic:latest .
```

Run command:
```
docker run --rm -it --gpus device=0 -v "$(pwd)"/TestB1:/data/test_data:ro -v "$(pwd)"/submission_output:/data/submission_output aic:latest /bin/bash run.sh
```

Run in docker command:
```
docker run --rm --gpus device=0 -it -v "$(pwd)"/test_data:/data/test_data -v "$(pwd)"/submission_output:/data/submission_output aic:latest /bin/bash
```
