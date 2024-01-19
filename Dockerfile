# Use the official Python image with version 3.10
FROM python:3.10

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set other environment variables
ENV RANK 0
ENV WORLD_SIZE 1
ENV MASTER_ADDR 0.0.0.0
ENV MASTER_PORT 2137
ENV NCCL_P2P_DISABLE 1

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
# WORKDIR /app

# Install poetry
RUN pip install poetry

# Copy the poetry files and install dependencies
COPY pyproject.toml poetry.lock .
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

# Copy the application code
COPY . .

# Copy the .env file for environment variables
COPY .env .

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["python", "main.py"]
