# Use the official Python base image
FROM python:3.10-slim

LABEL maintainer="alimaksudi"

# Create and activate virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the working directory
COPY requirements.txt .

# Copy the development requirements file to the working directory
COPY requirements.dev.txt .

# Install the project dependencies
RUN pip install --no-cache-dir -r requirements.txt  

# ARG instruction defines a build-time variable
ARG DEV=false # default value is false

# Install the development dependencies
RUN if [ "$DEV" = "true" ]; then pip install --no-cache-dir -r requirements.dev.txt; fi

# Copy the project files to the working directory
COPY . .

# Expose the port that the Django app will run on
EXPOSE 8000

# Set the PYTHONUNBUFFERED environment variable, which prevents Python from buffering stdout and stderr
# This allows you to log output from your application in real time
ENV PYTHONUNBUFFERED=1

# add a user to run the application
RUN adduser --disabled-password --gecos '' django-user

#User to run the application
USER django-user

# Set the command to run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]






