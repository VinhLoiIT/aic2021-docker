# aic2021-docker

Pull already built docker:
```
docker pull vinhloiit/aic2021
```

Or build using command:
```
docker build -t aic:latest .
```

Run command:
```
docker run --rm -it --gpus device=0 -v "$(pwd)"/TestB1:/data/test_data:ro -v "$(pwd)"/submission_output:/data/submission_output aic:latest /bin/bash run.sh
```
