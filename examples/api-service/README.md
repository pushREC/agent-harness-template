# API Service Example

Example specification for building a REST API service with FastAPI.

## Usage

```bash
# Copy app_spec.txt to your project prompts folder
cp app_spec.txt /path/to/project/prompts/app_spec.txt

# Run the agent
python3 autonomous_agent.py --project-dir ./product-api
```

## What Gets Built

- FastAPI application
- SQLAlchemy ORM with SQLite
- CRUD endpoints for products and categories
- Search and pagination
- OpenAPI documentation
- Error handling

## Expected Output

After 3-5 sessions:
- 30+ features implemented
- API tested with curl/httpie
- Swagger docs generated
