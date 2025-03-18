# Use the official Python 3.9 image with the correct architecture
FROM --platform=linux/amd64 python:3.9

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port (should match ECS Task Definition)
EXPOSE 5050

# Start Flask
CMD ["python", "app.py"]