#!/usr/bin/python

"""GetTaxonomy.py
   --------------
   Create taxonomic records for a species list 
   using the ITIS database.
   
   Requirements:
   --------------
   python with the libraries 
   - sys 
   - sqlite3
   
   Usage:
   ------
   python GetTaxonomy.py SpeciesList.txt Where/Is/The/File/ITIS.sqlite

   Input:
   -------
   A species list: text file with one record per line.
   Each record can be:
   - the latin binomial for the species
   - or the genus name 
   - or the family name

   A path to the ITIS database (SQLite version)
   This file can be downloaded from the page
   http://www.itis.gov/downloads/index.html
   Choose the SQLite version of the file, 
   and unzip the file somewhere (about 1/2 Gb)

   Output:
   -------
   A comma-separated text file .taxon containing all the taxonomic info
   The file name is obtained by adding .taxon to the path of the input file
   """

__author__ = 'Stefano Allesina (sallesina@uchicago.edu)'
__version__ = '0.0.9'

## libraries
import sqlite3
import sys

## Global variables
conn = None
c = None

def GetOneRecord(mystring):
    """ Match one record and reconstructs taxonomy
        It requires an open connection to the database
        (see code below)
    """
    # connection to the database
    global conn
    # cursor for the connection
    global c

    myData = {
        'tsn_species': 0,
        'tsn_genus': 0,
        'tsn_family': 0,
        'tsn_order': 0,
        'tsn_class': 0,
        'tsn_phylum': 0,
        'tsn_kingdom': 0,
        'name_input': "",
        'species': "",
        'genus': "",
        'family': "",
        'order': "",
        'class': "",
        'phylum': "",
        'kingdom': "",
        'log': ""
        }

    # sanitize the input
    # remove trailing spaces, newlines and tabs
    mystring = mystring.strip()
    # remove inner tabs
    mystring = mystring.replace("\t", " ")
    # remove commas
    mystring = mystring.replace(",", " ")
    # remove dots
    mystring = mystring.replace(".", " ")

    myData['name_input'] = mystring

    # split the text using spaces and take the first two words
    tmp = mystring.split(" ")
    myGenus = tmp[0]
    myGenus = myGenus.strip()
    mySpp = ""
    if (len(tmp) > 1):
        mySpp = tmp[1]
        mySpp = mySpp.strip()

    # try species first
    query1 = 'SELECT tsn, unit_name1, unit_name2, parent_tsn, rank_id, name_usage FROM taxonomic_units WHERE unit_name1 = "' + myGenus + '" AND unit_name2 = "' + mySpp + '" AND rank_id = 220'
    c.execute(query1)
    tmp = c.fetchall()
    if len(tmp) > 0:
        myData['log'] = "Species found"
        print "Species found"
        print tmp[0]

    if len(tmp) == 0:
        # try genus
        print "Could not find species -- trying with genus"
        query2 = 'SELECT tsn, unit_name1, unit_name2, parent_tsn, rank_id, name_usage FROM taxonomic_units WHERE unit_name1 = "' + myGenus + '" AND rank_id = 180'  
        c.execute(query2)
        tmp = c.fetchall()
        if len(tmp) > 0:
            myData['log'] = "Genus found"
            print "Genus found"
            print tmp[0]

    if len(tmp) == 0:
        # try family
        print "Could not find species nor genus -- trying with family"
        query2 = 'SELECT tsn, unit_name1, unit_name2, parent_tsn, rank_id, name_usage FROM taxonomic_units WHERE unit_name1 = "' + myGenus + '" AND rank_id = 140'  
        c.execute(query2)
        tmp = c.fetchall()
        if len(tmp) > 0:
            myData['log'] = "Family found"
            print "Family found"
            print tmp[0]

    # if record not found, quit
    if len(tmp) == 0:
        myData['log'] = "The name does not match Species nor Genus nor Family in the database"
        print "The name does not match Species nor Genus nor Family in the database"
        return myData

    ## If the name is not accepted, try to find synonym
    if not tmp[0][5] in [u'accepted', u'valid']:
        print "Name not valid: trying to find synonym"
        ## get the record from the list of synonyms
        querysyn = "SELECT tsn, tsn_accepted FROM synonym_links WHERE tsn = " + str(tmp[0][0])
        c.execute(querysyn)
        tmp = c.fetchall()
        if len(tmp) == 0:
            myData['log'] = myData['log'] + "Could not find valid TSN"
            return myData
        querysyn2 = 'SELECT tsn, unit_name1, unit_name2, parent_tsn, rank_id, name_usage FROM taxonomic_units WHERE tsn = ' + str(tmp[0][1])
        c.execute(querysyn2)
        tmp = c.fetchall()

    while len(tmp) > 0:
        # analyze record
        if tmp[0][4] == 220:
            # species
            myData['species'] = str(tmp[0][2])
            myData['tsn_species'] = tmp[0][0]
        if tmp[0][4] == 180:
            # genus
            myData['genus'] = str(tmp[0][1])
            myData['tsn_genus'] = tmp[0][0]
        if tmp[0][4] == 140:
            # family
            myData['family'] = str(tmp[0][1])
            myData['tsn_family'] = tmp[0][0]
        if tmp[0][4] == 100:
            # order
            myData['order'] = str(tmp[0][1])
            myData['tsn_order'] = tmp[0][0]
        if tmp[0][4] == 60:
            # class
            myData['class'] = str(tmp[0][1])
            myData['tsn_class'] = tmp[0][0]
        if tmp[0][4] == 30:
            # phylum
            myData['phylum'] = str(tmp[0][1])
            myData['tsn_phylum'] = tmp[0][0]
        if tmp[0][4] == 10:
            # kingdom
            myData['kingdom'] = str(tmp[0][1])
            myData['tsn_kingdom'] = tmp[0][0]
        # query recursively using parent_tsn (tmp[0][3])
        query3 = 'SELECT tsn, unit_name1, unit_name2, parent_tsn, rank_id, name_usage FROM taxonomic_units WHERE tsn = ' + str(tmp[0][3])
        c.execute(query3)
        tmp = c.fetchall()
    print myData
    return(myData)


def ProcessFile(filespplist, filesqlite):
    global conn
    global c
    # create a connection
    conn = sqlite3.connect(filesqlite)
    c = conn.cursor()
    # open text file
    f = open(filespplist)
    g = open(filespplist + ".taxon", "w")
    # keep a tally
    tried = 0
    found = 0
    g.write('input,tsn_species,tsn_genus,tsn_family,tsn_order,tsn_class,tsn_phylum,tsn_kingdom,species,genus,family,order,class,phylum,kingdom,log\n')
    for line in f:
        print "########################################################"
        print line
        tmp = GetOneRecord(line)
        g.write(tmp['name_input'] + ',' + str(tmp['tsn_species']) + ',' + str(tmp['tsn_genus']) + ',' + str(tmp['tsn_family']) + ',' + str(tmp['tsn_order']) + ',' + str(tmp['tsn_class']) + ',' + str(tmp['tsn_phylum']) + ',' + str(tmp['tsn_kingdom']) + ',' + tmp['species'] + ',' + tmp['genus'] + ',' + tmp['family'] + ',' + tmp['order'] + ',' + tmp['class'] + ',' + tmp['phylum'] + ',' + tmp['kingdom'] + ',' + tmp['log'] + '\n')
        if tmp['kingdom'] != '':
            found += 1
        tried += 1
        print "########################################################"
    conn.close()
    f.close()
    g.close()
    print "SUMMARY:"
    print "Records in the species list: " + str(tried)
    print "Records matched in the db: " + str(found)
    print "Proportion found: " + str( (100. * found)  / float(tried)) + '%'

if (__name__ == "__main__"):
    ProcessFile(sys.argv[1], sys.argv[2])
    sys.exit()
