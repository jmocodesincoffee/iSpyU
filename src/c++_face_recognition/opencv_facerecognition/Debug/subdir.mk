################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../colormap.cpp \
../decomposition.cpp \
../facedt.cpp \
../facerec.cpp \
../helper.cpp \
../lbp.cpp \
../subspace.cpp 

OBJS += \
./colormap.o \
./decomposition.o \
./facedt.o \
./facerec.o \
./helper.o \
./lbp.o \
./subspace.o 

CPP_DEPS += \
./colormap.d \
./decomposition.d \
./facedt.d \
./facerec.d \
./helper.d \
./lbp.d \
./subspace.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross G++ Compiler'
	g++ -I/usr/local/include/opencv -I/usr/local/include/boost -I/usr/local/include/opencv2 -I/usr/local/include/ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


