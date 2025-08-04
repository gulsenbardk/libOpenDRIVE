
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    build-essential cmake git

WORKDIR /libOpenDRIVE
COPY . .

RUN mkdir build && cd build \
    && cmake -DBUILD_SHARED_LIBS=ON .. \
    && make -j$(nproc) \
    && make install


FROM ubuntu:22.04

COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/include /usr/local/include
COPY --from=builder /usr/local/bin /usr/local/bin

#COPY --from=builder /libOpenDRIVE/data /usr/local/share/libOpenDRIVE


ENV LD_LIBRARY_PATH=/usr/local/lib

CMD ["/bin/bash"]