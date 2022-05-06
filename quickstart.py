import random
from aim import Run


# Several Runs as if we trained several models
train_run = 0

while train_run <= 5:

    # Initialize a Run
    run = Run(repo="aim://localhost:53800", experiment="test_experiment")

    # Run class provides a dictionary-like interface for storing training hyperparameters and other dictionary metadata:
    run['hparams'] = {
        'learning_rate': 0.001,
        'batch_size': 32,
    }

    # log some metrics
    random_int = random.randint(2000, 5000)
    random_int2 = random.randint(2, 10)
    run.track(random_int, name="metric_1")
    run.track(random_int2, name="metric_2")

    train_run += 1


