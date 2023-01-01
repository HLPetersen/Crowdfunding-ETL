/* Count the backers from all the live campaigns */
SELECT public.campaign.cf_id, public.campaign.backers_count FROM campaign
WHERE public.campaign.outcome = 'live'
GROUP BY public.campaign.cf_id
ORDER BY public.campaign.cf_id DESC;

/* Use backers table to double-check first query. */
SELECT public.backers.cf_id, count(public.backers.cf_id) FROM backers
GROUP BY public.backers.cf_id
ORDER BY public.backers.cf_id DESC;

/* Find the amount still needed for all live campaigns along with contact info. */
CREATE TABLE contact_goal AS
SELECT public.campaign.contact_id,
public.campaign.goal - public.campaign.pledged as left_of_goal 
FROM campaign
WHERE outcome = 'live';

CREATE TABLE email_contacts_remaining_goal_amount AS
SELECT c.first_name, c.last_name, c.email, g.left_of_goal AS Remaining_Goal_Amount
FROM contacts AS c
INNER JOIN contact_goal AS g
ON c.contact_id = g.contact_id
ORDER BY left_of_goal DESC;

/* Create a table for the backers with the amount remaining of goal.*/
CREATE TABLE backer_goal AS
SELECT public.campaign.cf_id, 
public.campaign.company_name,
public.campaign.description,
public.campaign.end_date,
public.campaign.goal - public.campaign.pledged AS left_of_goal 
FROM campaign
WHERE outcome = 'live';

CREATE TABLE email_backers_remaining_goal_amount AS
SELECT b.email, b.first_name, b.last_name, 
l.cf_id, l.company_name, l.description, l.end_date, l.left_of_goal
FROM public.backers AS b
INNER JOIN public.backer_goal AS l
ON b.cf_id = l.cf_id
ORDER BY b.last_name;

SELECT * FROM email_backers_remaining_goal_amount