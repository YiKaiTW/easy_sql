test-coverage:
	export PYSPARK_PYTHON=python3 && export PYSPARK_DRIVER_PYTHON=python3 && \
 		python3 -m coverage run -m unittest discover -s easy_sql -t . -p '*_test.py'
	python3 -m coverage report -m
	- mkdir build
	- rm -r build/coverage
	python3 -m coverage html

unit-test:
	export PYSPARK_PYTHON=python3 && export PYSPARK_DRIVER_PYTHON=python3 && \
 		python3 -m unittest discover -s easy_sql -t . -p '*_test.py'

# Note: env var named PG_URL and CLICKHOUSE_URL must be set to run e2e test
e2e-test:
	cd test && docker build . --build-arg PG_URL=${PG_URL} --build-arg CLICKHOUSE_URL=${CLICKHOUSE_URL}

echo-var:
	echo ${PG_URL} ${CLICKHOUSE_URL}

e2e-test-spark:
	python3 -m easy_sql.data_process -f test/sample_etl.spark.sql

e2e-test-postgres:
	python3 -m easy_sql.data_process -f test/sample_etl.postgres.sql

e2e-test-clickhouse:
	python3 -m easy_sql.data_process -f test/sample_etl.clickhouse.sql

e2e-test-flink-postgres:
	python3 -m easy_sql.data_process -f test/sample_etl.flink.postgres.sql

test-coverage-all:
	export PYSPARK_PYTHON=python3 && export PYSPARK_DRIVER_PYTHON=python3 && \
 		PG_URL=${PG_URL} CLICKHOUSE_URL=${CLICKHOUSE_URL} python3 -m coverage run -m unittest discover -s easy_sql -t . -p '*test.py'
	python3 -m coverage report -m
	python3 -m coverage xml

package-pip:
	python3 -m pip install --upgrade build
	python3 -m build
	# It looks like the build command will remove files in easy_sql directory, restore it after a build
	git restore easy_sql

upload-test-pip:
	python3 -m pip install --upgrade twine
	python3 -m twine upload --repository testpypi dist/*

install-test-pip:
	pip3 uninstall easy_sql-easy_sql
	python3 -m pip install --index-url https://test.pypi.org/simple/ easy_sql-easy_ql

upload-pip:
	python3 -m pip install --upgrade twine
	python3 -m twine upload dist/*
