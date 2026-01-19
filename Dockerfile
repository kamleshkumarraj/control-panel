FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Correct and consistent paths
WORKDIR /app/control-panel

ENV VIRTUAL_ENV=/app/control-panel/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir uv

# Create venv INSIDE project directory
RUN uv venv .venv

# Install packages into the SAME venv
RUN uv pip install \
    django \
    djangorestframework \
    djangorestframework-simplejwt \
    cryptography

# Copy project files AFTER venv exists
COPY ./control-panel .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]