from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import os
import csv
import numpy
import cgi
import json
import subprocess as sp
import sys
import matlab.engine

#Create custom HTTPRequestHandler class
class KodeFunHTTPRequestHandler(BaseHTTPRequestHandler):


  # Handle POST command
  def do_GET(self):
     
    #length = int(self.headers.getheader('content-length'))
    postvars = self.path
    input = eval('[' + find_between(postvars, '[', ']') + ']')

    output = calc_for(numpy.array(input))
    
    resp = '{BombChance: ' + str([e[0] for e in output])+ '}'

    #send code 200 response
    self.send_response(200)

    #send header first
    self.send_header('Content-type','text/plain ')
    self.end_headers()

    #send file content to client
    self.wfile.write(resp)

  # Handle POST command
  def do_POST(self):
    
    ctype, pdict = cgi.parse_header(self.headers.getheader('content-type'))
 
    if ctype == 'application/json':
        length = int(self.headers.getheader('content-length'))
        postvars = str(cgi.parse_qs(self.rfile.read(length), keep_blank_values=1))
        input = eval('[' + find_between(postvars, '[', ']') + ']')

        print numpy.array(input)
        output = calc_for(numpy.array(input))
        
        resp = '{\"BombChance\": ' + str([e[0] for e in output])+ '}'

        #send code 200 response
        self.send_response(200)

        #send header first
        self.send_header('Content-type','text/plain ')
        self.end_headers()

        #send file content to client
        self.wfile.write(resp)



    else:
        postvars = {}
  

def parse_weights():

  weights = []

  reader = csv.reader(open("Weights1.csv", "rb"), delimiter=",")
  x = list(reader)
  weights.append(numpy.array(x).astype("float"))

  reader = csv.reader(open("Weights2.csv", "rb"), delimiter=",")
  x = list(reader)
  weights.append(numpy.array(x).astype("float"))

  return weights

def parse_biases():

  biases = []

  reader = csv.reader(open("Biases1.csv", "rb"), delimiter=",")
  x = list(reader)
  biases.append(numpy.array(x).astype("float"))

  reader = csv.reader(open("Biases2.csv", "rb"), delimiter=",")
  x = list(reader)
  biases.append(numpy.array(x).astype("float"))
  
  return biases

def calc_for(input):

  weights = parse_weights()
  biases = parse_biases()
  
  layer_1_resaults = tansig(numpy.dot(weights[0], input) + numpy.transpose(biases[0]))
  layer_2_resaults = softmax(numpy.dot(weights[1], numpy.transpose(layer_1_resaults)) + biases[1])

  return list(layer_2_resaults)

  
def tansig(a):
  return numpy.divide(2,  (1 + numpy.exp(-2*a))) - 1

def softmax(a):
  return numpy.divide(numpy.exp(a), numpy.sum(numpy.exp(a)))

def find_between( s, first, last ):
    try:
        start = s.index( first ) + len( first )
        end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""


def run():

  # Train Net
  print 'Training Neural Net'
  eng = matlab.engine.start_matlab()
  eng.Net()


  #ip and port of servr
  #by default http server port is 80
  server_address = ('0.0.0.0', 8080)
  httpd = HTTPServer(server_address, KodeFunHTTPRequestHandler)

  print('HTTP server is running...')
  httpd.serve_forever()
  
if __name__ == '__main__':
  run()