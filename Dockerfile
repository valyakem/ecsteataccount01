# start by pulling the python image
FROM python:3.8-alpine

# copy the requirements file into the image
COPY ./flaskapp/requirements.txt /app/requirements.txt

# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements file
RUN pip install -r requirements.txt

# copy every content from the local file to the image
COPY ./flaskapp /app

EXPOSE 5000
# configure the container to run in an executed manner
ENTRYPOINT [ "python3" ]

CMD ["main.py" ]