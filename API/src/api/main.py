from contextlib import asynccontextmanager
from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession
from api.db import AsyncSessionLocal, engine, get_db
from api.storage import ensure_bucket_exists, get_s3_client


@asynccontextmanager
async def lifespan(app: FastAPI):
    async with AsyncSessionLocal() as session:
        await session.execute(text("SELECT 1"))
    ensure_bucket_exists()
    yield
    await engine.dispose()


app = FastAPI(lifespan=lifespan)


@app.get("/health")
async def health(db: AsyncSession = Depends(get_db)):
    try:
        await db.execute(text("SELECT 1"))
        get_s3_client().head_bucket(Bucket="bone-photos")
    except Exception as exc:
        raise HTTPException(status_code=503, detail=str(exc)) from exc
    return {"status": "ok"}