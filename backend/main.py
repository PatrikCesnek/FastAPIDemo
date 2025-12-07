#main.py
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import httpx
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="Proxy API for JSONPlaceholder")

app.add_middleware (
    CORSMiddleware,
    allow_origins = ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

PROXY_TARGET = os.getenv("PROXY_TARGET", "https://jsonplaceholder.typicode.com")

client = httpx.AsyncClient(timeout = 10.0)

@app.on_event("shutdown")
async def shutdown_event():
    await client.aclose()

@app.get("/api/posts")
async def get_posts():
    """Return list of posts (proxied from JSONPlaceholder)."""
    url = f"{PROXY_TARGET}/posts"
    try:
        resp = await client.get(url)
        resp.raise_for_status()
        return resp.json()
    except httpx.HTTPStatusError as exc:
        raise HTTPException(status_code=exc.response.status_code, detail=str(exc))
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))

@app.get("/api/posts/{post_id}")
async def get_post(post_id: int):
    """Return single post by id (proxied)."""
    url = f"{PROXY_TARGET}/posts/{post_id}"
    try:
        resp = await client.get(url)
        if resp.status_code == 404:
            raise HTTPException(status_code=404, detail="Post not found")
        resp.raise_for_status()
        return resp.json()
    except httpx.HTTPStatusError as exc:
        raise HTTPException(status_code=exc.response.status_code, detail=str(exc))
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


