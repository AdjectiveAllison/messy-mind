#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define MAX_THREADS 10

// This is the function that will be run in a new thread
void *threadFunction(void *threadid) {
    long tid;
    tid = (long)threadid;
    for(int i = 0; i < 10; i++) {
        printf("Thread #%ld, counter value: %d\n", tid, i);
        sleep(1); // delay for demonstration purposes
    }
    pthread_exit(NULL);
}

int main(int argc, char *argv[]) {
    pthread_t threads[MAX_THREADS];
    int rc;
    long t;

    for(int numThreads = 1; numThreads <= 4; numThreads *= 2) { // 1, 2, 4 threads
        printf("\n-----Testing with %d threads-----\n", numThreads);
        for(t = 0; t < numThreads; t++) {
            printf("Creating thread %ld\n", t);
            rc = pthread_create(&threads[t], NULL, threadFunction, (void *)t);
            if (rc) {
                printf("ERROR; return code from pthread_create() is %d\n", rc);
                exit(-1);
            }
        }
        // join threads
        for(t = 0; t < numThreads; t++) {
            pthread_join(threads[t], NULL);
        }
    }
    pthread_exit(NULL);
}
