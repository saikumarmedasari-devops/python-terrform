
import pytest
from app import app, add, subtract, multiply, divide


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


# Unit tests

def test_add():
    assert add(10, 5) == 15


def test_subtract():
    assert subtract(10, 5) == 5


def test_multiply():
    assert multiply(10, 5) == 50


def test_divide():
    assert divide(10, 5) == 2


def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)


# Flask API tests

def test_home(client):
    response = client.get("/")
    assert response.status_code == 200
    assert b"Python Calculator" in response.data


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json["status"] == "healthy"


def test_calculate_api(client):
    response = client.get(
        "/calculate?a=10&b=5&operation=add"
    )
    assert response.status_code == 200
    assert response.json["result"] == 15


def test_invalid_operation(client):
    response = client.get(
        "/calculate?a=10&b=5&operation=power"
    )
    assert response.status_code == 400


def test_api_divide_by_zero(client):
    response = client.get(
        "/calculate?a=10&b=0&operation=divide"
    )
    assert response.status_code == 400
