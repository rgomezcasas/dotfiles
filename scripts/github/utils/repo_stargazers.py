#!/usr/bin/python2.7

# CREDITS: https://raw.githubusercontent.com/minimaxir/get-profile-data-of-repo-stargazers/master/repo_stargazers.py
# Has some editions (passing arguments)

### Script to get GitHub profile data of all Stargazers of a given GitHub repository
###
###	by Max Woolf (@minimaxir)

import json
import csv
import urllib2
import datetime
import time
import argparse

parser = argparse.ArgumentParser()
parser.add_argument( "-t","--token",help="auth token (required)" )
parser.add_argument( "-r","--repo",help="repository (required)" )
parser.add_argument( "-p","--path",help="path on csv is created (required)" )
parser.parse_args()
args = parser.parse_args()

access_token = args.token
repo = args.repo
path = args.path

fields = ["user_id", "username", "num_followers", "num_following", "num_repos","created_at","star_time"]
page_number = 0
users_processed = 0
stars_remaining = True
list_stars = []

print "Gathering Stargazers for %s..." % repo

###
###	This block of code creates a list of tuples in the form of (username, star_time)
###	for the Statgazers, which will laterbe used to extract full GitHub profile data
###

while stars_remaining:
	query_url = "https://api.github.com/repos/%s/stargazers?page=%s&access_token=%s" % (repo, page_number, access_token)

	req = urllib2.Request(query_url)
	req.add_header('Accept', 'application/vnd.github.v3.star+json')
        try:
	    response = urllib2.urlopen(req)
        except:
            pass
	data = json.loads(response.read())

	for user in data:
		username = user['user']['login']

		star_time = datetime.datetime.strptime(user['starred_at'],'%Y-%m-%dT%H:%M:%SZ')
		star_time = star_time + datetime.timedelta(hours=-5) # EST
		star_time = star_time.strftime('%Y-%m-%d %H:%M:%S')

		list_stars.append((username, star_time))

	if len(data) < 25:
		stars_remaining = False

	page_number += 1

print "Done Gathering Stargazers for %s!" % repo

list_stars = list(set(list_stars)) # remove dupes

print "Now Gathering Stargazers' GitHub Profiles..."

###
###	This block of code extracts the full profile data of the given Stargazer
###	and writes to CSV
###

with open(path, 'wb') as stars:

	stars_writer = csv.writer(stars)
	stars_writer.writerow(fields)

	for user in list_stars:
		username = user[0]

		query_url = "https://api.github.com/users/%s?access_token=%s" % (username, access_token)

		req = urllib2.Request(query_url)
                try:
		    response = urllib2.urlopen(req)
                except:
                    pass
		data = json.loads(response.read())

		user_id = data['id']
		num_followers = data['followers']
		num_following = data['following']
		num_repos = data['public_repos']

		created_at = datetime.datetime.strptime(data['created_at'],'%Y-%m-%dT%H:%M:%SZ')
		created_at = created_at + datetime.timedelta(hours=-5) # EST
		created_at = created_at.strftime('%Y-%m-%d %H:%M:%S')

		stars_writer.writerow([user_id, username, num_followers, num_following, num_repos, created_at, user[1]])

		users_processed += 1

		if users_processed % 100 == 0:
			print "%s Users Processed: %s" % (users_processed, datetime.datetime.now())

		time.sleep(1) # stay within API rate limit of 5000 requests / hour + buffer
