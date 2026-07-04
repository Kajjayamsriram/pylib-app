FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copying app.py and templates
COPY app.py .
COPY templates ./templates
RUN useradd -m -s /bin/bash sriram && \
    chown -R sriram:sriram /app
USER sriram
EXPOSE 5000

CMD ["python", "app.py"]

