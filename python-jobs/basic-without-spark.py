from datetime import datetime 
data = [i for i in range(1,2000000)]



start_time = datetime.now() 
print("Sum is:",sum(data))
time_elapsed = datetime.now() - start_time
print(f"took {time_elapsed} seconds")


start_time = datetime.now() 
print("Len is:",len(data))
time_elapsed = datetime.now() - start_time
print(f"took {time_elapsed} seconds")