from decimal import *

def cls():
    print"\n"*500

cls()

b=[]
golden_results_dut_1=[]
golden_results_dut_2=[]

max_test_config_cases=460
max_inputs_per_test=16
no_inputs_dut=4

test_results_dut_1 = [[] for i in range(max_test_config_cases)]
test_results_dut_2 = [[] for i in range(max_test_config_cases)]

joint_detectability_matrix =[[] for i in range(max_test_config_cases)]


file =open("C:/Users/Mihir Shah/Desktop/c_code/data_result.txt","r")
data=file.read()

for line in open("C:/Users/Mihir Shah/Desktop/c_code/data_result.txt"):
    for x in range (0,max_test_config_cases): 
        if str(x)+"_Test_Configuration:" in line:
            a=line
            a=a.split(":")
            b.append(a[1].rstrip())
            print "Test Configuration No " + str(x)+":"+ b[x]


file.seek(0)
print "\n"
for line in open("C:/Users/Mihir Shah/Desktop/c_code/data_result.txt"):
    for i in range(0,max_test_config_cases):
        if str(",")+str(b[i]) in line:
            if i==0:
                c=line
                c=c.split(",")
                golden_results_dut_1.append(c[2].rstrip())
                golden_results_dut_2.append(c[4].rstrip())
            else:
                c=line
                c=c.split(",")
                test_results_dut_1[i].append(c[2].rstrip())
                test_results_dut_2[i].append(c[4].rstrip())
                
file.close()

print "Golden_DUT_1" + str(golden_results_dut_1) + "\n"
print "Golden_DUT_2" + str(golden_results_dut_2) + "\n"

print "Test_DUT_1" + str(test_results_dut_1) + "\n"
print "Test_DUT_2" + str(test_results_dut_2) + "\n"

for k in range (1,max_test_config_cases):
    count=0
    for j in range (0,max_inputs_per_test):
        if ((test_results_dut_1[k][j]!=golden_results_dut_1[j]) and (test_results_dut_2[k][j]!=golden_results_dut_2[j])):
            if(golden_results_dut_1[j]==golden_results_dut_2[j]):
                print "Found Joint Detectability " + " @k:" + str(k) + " @j:" + str(j) + "\n"
                count=count+1;        
                joint_detectability_matrix[k].append(count)

count_JD=0; 
for m in range(1,max_test_config_cases):
    if not joint_detectability_matrix[m]:
        count_JD=count_JD+1
    else:
        Joint_detect = (1-(Decimal(joint_detectability_matrix[m][0])/ Decimal(pow(2,no_inputs_dut))))


D_metric = Decimal(Joint_detect+count_JD)/Decimal(max_test_config_cases-1)
print "D_metric:" + str(D_metric)
