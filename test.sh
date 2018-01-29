#!/bin/sh

NOTFOUND="Sorry"
WRONG_JSON="Wrong JSON"
EMPTY=""

# =========== Negative tests =======================

if [ "$(curl --request DELETE --url http://localhost:8080/messages/1)" = "$NOTFOUND" ]; then
    echo "OK"
else
    echo "Test 1 failed"
    exit 2
fi

if [ "$(curl --request GET --url http://localhost:8080/messages/2)" = "$NOTFOUND" ]; then
    echo "OK"
else    
    echo "Test 2 failed"
    exit 2
fi

if [ "$(curl --request POST \
            --url http://localhost:8080/messages/ \
            --header 'Content-Type: application/json' \
            --data '{
            "i2d" : 1,
            "text2" : "Test text"
            }')" = "$WRONG_JSON" ]; then
    echo "OK"
else    
    echo "Test 3 failed"
    exit 2
fi

if [ "$(curl --request PUT \
            --url http://localhost:8080/messages/1 \
            --header 'Content-Type: application/json' \
            --data '{
            "text" : "Some new text"
            }')" = "$NOTFOUND" ]; then
    echo "OK"
else    
    echo "Test 4 failed"
    exit 2
fi


# ============ Positive scenarios ====================

# Test 1: Get an empty list of messages
if [ "$(curl --request GET --url http://localhost:8080/messages/)" = "{}" ]; then
  echo "OK"
else
  echo "Test 5 failed"
  exit 2
fi

# Test 2: Get specific id
if [ "$(curl --request GET --url http://localhost:8080/messages/1/)" = "${NOTFOUND}" ]; then
  echo "OK"
else
  echo "Test 6 failed"
  exit 2
fi

# Test 3: Add a record
if [ "$(curl --request POST \
            --url http://localhost:8080/messages/ \
            --header 'Content-Type: application/json' \
            --data '{
            "id" : 1,
            "text" : "Test text"
            }' )" = "${EMPTY}" ]; then
  echo "OK"
else
  echo "Test 7 failed"
  exit 2
fi

# Test 4: Get all messages
if [ "$(curl --request GET --url http://localhost:8080/messages/)" = '{"1":{"id":"1","text":"Test text"}}' ]; then
  echo "OK"
else
  echo "Test 8 failed"
  exit 2
fi

# Test 5: Update message
if [ "$(curl --request PUT \
            --url http://localhost:8080/messages/1 \
            --header 'Content-Type: application/json' \
            --data '{
            "text" : "Some new text"
            }')" = "$EMPTY" ]; then
  echo "OK"
else
  echo "Test 9 failed"
  exit 2
fi

# Test 6: Get specific id
if [ "$(curl --request GET --url http://localhost:8080/messages/1/)" = '{"id":"1","text":"Some new text"}' ]; then
  echo "OK"
else
  echo "Test 10 failed"
  exit 2
fi

# Test 7: Delete record
if [ "$(curl --request DELETE --url http://localhost:8080/messages/1/)" = "$EMPTY" ]; then
  echo "OK"
else
  echo "Test 11 failed"
  exit 2
fi

# Test 8: Get specific id
if [ "$(curl --request GET --url http://localhost:8080/messages/1/)" = "$NOTFOUND" ]; then
  echo "OK"
else
  echo "Test 12 failed"
  exit 2
fi

echo "All tests passed"
