/*
Questions:
1) Could you find what is the gender ratio in each game?
2) Try to list the youngest and oldest player per country.
3) If you suddenly had millions of new events for the accounts to process per day, how would
you make the data pipeline faster and more scalable and more reliable? 
Bonus) Can you summarize a list of principles you would follow when developing an event pipeline?
*/

/*
Answers:
*/

/*01 - get count by gender and game*/
SELECT acct.src_sys, gen.gender, 
	COUNT(gen.gender) as gender_count,
    round(COUNT(gen.gender) / SUM(COUNT(acct.src_sys)) OVER (PARTITION BY acct.src_sys),4) as ratio
FROM layer1.user_account as acct
join layer1.lov_gender as gen
	on acct.gender_id = gen.gender_id
GROUP BY acct.src_sys, gen.gender;

/*02 - youngest and oldest player per country*/
select
	src.country_id,
	AGE(src.max_dob) as youngest_user,
	AGE(src.min_dob) as oldest_user
FROM
	(	
		SELECT 
			acct.country_id,
			MIN(acct.date_of_birth) OVER (PARTITION BY acct.country_id) as min_dob,
			MAX(acct.date_of_birth) OVER (PARTITION BY acct.country_id) as max_dob
		FROM layer1.user_account as acct
		GROUP BY acct.country_id, acct.date_of_birth
	) as src
group by 
	src.country_id,	
	AGE(src.min_dob),	
	AGE(src.max_dob)
order by src.country_id


/* 03 - make the data pipeline faster and more scalable and more reliable */
/*
- use multiple CPU cores to execute a single query faster with the parallel query feature
- use partitioning
- load-balancing over multiple databases
- e.g. on Postgres - usePgpool-II, which can work as a load-balancer in front of several PostgreSQL databases. 
	It exposes a SQL interface, and applications can connect there as if it were a real PostgreSQL server. 
	Then Pgpool-II redirects the queries to the databases that are executing the fewest queries at that moment.
- data sharding - table partitioning, where partitions are located on different servers and the master server, uses them as foreign tables
- keeping most of the data cleaning and processing in separate environments, e.g. using Python
- ensure with data owners only necessary data is exported and imported. E.g. wwc export contains detailed account information - do the analysts need that?
- doing data analysis on copy of the data at the client servers/computers in virtual environments
- monitoring systems 
	- IT monitoring tools - Grafana, Datadog
	- Data monitoring tools - latency, missing data, inconsistent dataset
	
*/

/* 04 - list of principles you would follow when developing an event pipeline */
/*
- use some of the available technologies: Apache Kafka, AWS Kinesis, RabbitMQ, AWS SMS, Azure Service Bus Event Hub, and Google Pub/Sub

*/