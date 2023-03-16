-- We need to figure out when to schedule an ad campaign. What day of the week do most users create an account on?
SELECT 
	DAYNAME(created_at) as day, 
    COUNT(*) as total 
FROM users
GROUP BY day
ORDER BY total DESC;

-- We want to target inactive users with an email campaign. Find the users who have never posted a photo
SELECT 
	username 
FROM users
LEFT JOIN photos ON photos.user_id = users.id
WHERE photos.id IS NULL;

-- We’re running a contest to see who can get the most likes on a single photo. Who won?
SELECT 
    username,
    photos.id,
    photos.image_url, 
    COUNT(*) AS total
FROM photos
INNER JOIN likes ON likes.photo_id = photos.id
INNER JOIN users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;

-- Our investors want to know→ how many times does the average user post?
SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) 
FROM users) AS avg; 

-- A brand wants to know which hashtags to use in a post. What are the top 5 most commonly used hashtags?
SELECT 
	tag_name, 
    COUNT(tags.id) as total 
FROM tags
JOIN photo_tags ON photo_tags.tag_id = tags.id
GROUP BY tags.id
ORDER BY COUNT(tags.id) DESC
LIMIT 5;

-- We have a problem with bots on our site. Find users who have liked every single photo on the site.
SELECT username, 
       Count(*) AS num_likes 
FROM users 
INNER JOIN likes ON users.id = likes.user_id 
GROUP BY likes.user_id 
HAVING num_likes = (SELECT Count(*) 
FROM photos); 
                    

