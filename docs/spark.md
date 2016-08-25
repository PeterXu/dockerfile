

### spark commands

run-example <class> [params] 
run-example SparkPi 10

spark-shell --master local[2]

pyspark --master local[2]
spark-submit examples/src/main/python/pi.py 10

sparkR --master local[2]
spark-submit examples/src/main/r/dataframe.R
