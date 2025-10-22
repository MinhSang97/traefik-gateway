from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import uvicorn

app = FastAPI(
    title="Product Service",
    description="Python FastAPI Product Service",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Models
class Product(BaseModel):
    id: int
    name: str
    price: float
    description: str

# Routes
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "product-service",
        "timestamp": "2024-01-01T00:00:00Z"
    }

@app.get("/products/", response_model=List[Product])
async def get_products():
    return [
        Product(id=1, name="Laptop", price=999.99, description="High-performance laptop"),
        Product(id=2, name="Mouse", price=29.99, description="Wireless mouse"),
        Product(id=3, name="Keyboard", price=79.99, description="Mechanical keyboard")
    ]

@app.get("/products/{product_id}", response_model=Product)
async def get_product(product_id: int):
    return Product(
        id=product_id, 
        name=f"Product {product_id}", 
        price=99.99, 
        description=f"Description for product {product_id}"
    )

@app.get("/docs/")
async def get_docs():
    return {"message": "FastAPI documentation available at /docs"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
