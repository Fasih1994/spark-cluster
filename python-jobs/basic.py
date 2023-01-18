print("Start ...")
  
from pyspark.sql import SparkSession
spark = SparkSession \
       .builder \
       .master('yarn') \
       .config('spark.yarn.queue', 'dev') \
       .appName("Test Application") \
       .getOrCreate()

print("Spark Object is created")
print("Spark Version used is :" + spark.sparkContext.version)

data = [i for i in range(1,2000000)]
df=spark.sparkContext.parallelize(data)
print("The count is:",df.count())
print("The sum is:",df.sum())


print("... End")