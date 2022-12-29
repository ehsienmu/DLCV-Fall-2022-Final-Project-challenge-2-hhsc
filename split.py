import argparse
parser = argparse.ArgumentParser()
parser.add_argument("--train_file", type=str, default=64)
parser.add_argument("--split_train", type=str, default=2)
parser.add_argument("--split_val", type=str, default=2)
# parser.add_argument("--optim",help="choose",default="adam")
args = parser.parse_args()
file_obj = open(args.train_file, "r")
  
# reading the data from the file
file_data = file_obj.read()
  
# splitting the file data into lines
lines = file_data.splitlines()
print(lines)
count = len(lines)
file_obj.close()

with open(args.split_train, 'w') as f:
    for line in lines[:int(count*0.8)]:
        f.write(f"{line}\n")

with open(args.split_val, 'w') as f:
    for line in lines[int(count*0.8):]:
        f.write(f"{line}\n")