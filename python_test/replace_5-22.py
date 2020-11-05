import re
import sys
import os

desktopPath =os.path.join(os.path.expanduser("~"), 'Desktop')
waveDrawLogPath = desktopPath  + "/WaveDrawLog"
#filePath = desktopPath  + "/Backlight_DOE/Raw_data_log/LED_IO2_CURRENT_med.txt"
filePath = sys.argv[1]

def function_32(data):
    Vref = 0.5
    volt = data
    if(data >= 0x80000000):
        volt = data-pow(2, 32)

    # print("volt1=", volt)
    volt = volt / 100.0
    # print("volt2=", volt)
    volt = volt / pow(2, 11)
    volt = volt * Vref
    return volt

def sum_32(data_list, ch):
        new_str = ''
        for i in range(int(len(data_list) / 4)):
            data=  data_list[i * 4 + 0] + (data_list[i * 4 + 1] * pow(2, 8)) + (data_list[i * 4 + 2] * pow(2,16))+(data_list[i*4+3]*pow(2,24))             
            volt = function_32(data)
            data_value_list.append(volt)

        fo = open(waveDrawLogPath+"/new_"+str(ch) + ".csv", "w")
        for line in data_value_list:
            if ch == 7:
                new_str = new_str +str(line) + ','
            
            fo.write(str(line) + ',\r\n')

        fo.close()

        if ch == 7:
            print("new_7_start:"+new_str+"new_7_end")

def list_create(datalist):
    buff = []
    # buff.append(0)
    for z in datalist:
        buff.append(z)
    return buff


def open_file(path):
    file=open(path,"r")
    str=file.read()
    file.close()
    return str


if __name__ == "__main__":

    isExists=os.path.exists(waveDrawLogPath)
    if not isExists:
        os.makedirs(waveDrawLogPath)
    print(filePath)
    data_value_list = []
    buf3 = []
    buf2 = []
    x = 0
    y = 0
    a = 0
    value0 = []
    value1 = []
    value2 = []
    value3 = []
    value4 = []
    value5 = []
    value6 = []
    value7 = []

    buf=open_file(filePath)
    buf=buf.rstrip()
    buf=buf.replace('0x','')
    buf=buf.replace('\r','')
    buf=buf.replace('\n','')
    buf_list=buf.split(':');
#    if len(buf_list)<2:
#        return ''
    buf = buf_list[1]

#    print(buf)

    result1 = []
    result = re.sub(' ', ',0x', buf)

    # with open('re.txt', 'w') as f:
    #     f.write(result)

    buf12 = re.split(',', str(result))
    buf13 = []
    for i in buf12:
        buf13.append(int(i, 16))

    for ii in buf13:
        # buf2 = buf1[16:-4]
        # with open('re1.txt', 'w') as f:
        #     f.write(str(buf2))
        if a <= 2047:
            a += 1
            buf2.append(ii)
        if a > 2047:
            a = 0
#            print("strat:" + str(buf2[:20]))
            for i in buf2[16:-4]:
                if x <= 3:
                    x = x + 1
                    buf3.append(i)
                if x > 3:
                    x = 0
                    # y += 1
                    if buf3[0] == 0x00:
                        for z in buf3:
                            value0.append(z)
                    elif buf3[0] == 0x01:
                        for z in buf3:
                            value1.append(z)
                    elif buf3[0] == 0x02:
                        for z in buf3:
                            value2.append(z)
                    elif buf3[0] == 0x03:
                        for z in buf3:
                            value3.append(z)
                    elif buf3[0] == 0x04:
                        for z in buf3:
                            value4.append(z)
                    elif buf3[0] == 0x05:
                        for z in buf3:
                            value5.append(z)
                    elif buf3[0] == 0x06:
                        for z in buf3:
                            value6.append(z)
                    elif buf3[0] == 0x07:
                        for z in buf3:
                            value7.append(z)
                    buf3 = []
            buf2 = []

    sum_32(value0, 0)
    sum_32(value1, 1)
    sum_32(value2, 2)
    sum_32(value3, 3)
    sum_32(value4, 4)
    sum_32(value5, 5)
    sum_32(value6, 6)
    sum_32(value7, 7)
