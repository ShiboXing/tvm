mkdir -p build
pushd build
rm -f config.cmake
cp ../cmake/config.cmake .

# controls default compilation flags (Candidates: Release, Debug, RelWithDebInfo)
echo "set(CMAKE_BUILD_TYPE RelWithDebInfo)" >> config.cmake

# LLVM is a must dependency for compiler end
echo "set(USE_LLVM \"llvm-config --ignore-libllvm --link-static\")" >> config.cmake
echo "set(HIDE_PRIVATE_SYMBOLS ON)" >> config.cmake

# GPU SDKs, turn on if needed
echo "set(USE_CUDA   ON)" >> config.cmake
echo "set(USE_METAL  OFF)" >> config.cmake
echo "set(USE_VULKAN OFF)" >> config.cmake
echo "set(USE_OPENCL OFF)" >> config.cmake

# cuBLAS, cuDNN, cutlass support, turn on if needed
echo "set(USE_CUBLAS ON)" >> config.cmake
echo "set(USE_CUDNN  ON)" >> config.cmake
echo "set(USE_CUTLASS OFF)" >> config.cmake

cmake \
    -DCUDA_INCLUDE_DIRS=/usr/local/lib/python3.12/dist-packages/nvidia/cudnn/include/ \
    -DCUDA_CUDNN_INCLUDE_DIRS=/usr/local/lib/python3.12/dist-packages/nvidia/cudnn/include/ \
    -DCUDA_CUBLAS_LIBRARY=/usr/local/cuda-12.1/targets/x86_64-linux/lib/libcublas.so \
    -DCUDA_CUDNN_LIBRARY=/usr/local/lib/python3.12/dist-packages/nvidia/cudnn/lib/libcudnn.so.9 \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_INCLUDE_PATH="/usr/local/cuda/targets/x86_64-linux/include;\
        /usr/local/lib/python3.12/dist-packages/nvidia/cudnn/include/" \
    .. && cmake --build . --parallel 128
