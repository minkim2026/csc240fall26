/*
< Recruitment Tracking System >
1. Database Tables
  • Job: job_id, title, department, description, posting_date, closing_date, is_active
  • Applicant: applicant_id, first_name, last_name, email, phone
  • Application: application_id, applicant_id, job_id, application_date, status(Applied, Interview, Accepted, Rejected)
  • Interview: interview_id, application_id, interview_datetime, result(Pending, Passed, Failed)
2. Stored Procedures
  • apply_for_job()
  • update_application_status()
  • schedule_interview()
3. Functions
  • get_application_count_by_job()
  • get_job_count_by_department()
4. Triggers
  • after_application_status_update
  • after_interview_insert
5. Permissions
  • grant
*/

-- 1. Database Tables

create database recruitment;

use recruitment;

create table job (
	`job_id` mediumint unsigned primary key auto_increment,
    `title` varchar(100) not null,
    `department` varchar(50) not null,
    `description` varchar(500) not null,
    `posting_date` date not null default (current_date),
    `closing_date` date,
    `is_active` boolean not null default true,
    check (
		closing_date is null
        or closing_date >= posting_date
	)    
);

create table applicant (
	`applicant_id` mediumint unsigned primary key auto_increment,
    `first_name` varchar(50) not null,
    `last_name` varchar(50) not null,
    `email` varchar(100) not null unique,
    `phone` varchar(20) not null unique
);

create table application (
	`application_id` mediumint unsigned primary key auto_increment,
    `applicant_id` mediumint unsigned not null,
    `job_id` mediumint unsigned not null,
    `application_date` date not null default (current_date),
    `status` enum('Applied', 'Interview', 'Accepted', 'Rejected') not null default 'Applied',
    foreign key(`applicant_id`) references applicant(`applicant_id`),
    foreign key(`job_id`) references job(`job_id`),
    unique(`applicant_id`, `job_id`)
);

create table interview (
	`interview_id` mediumint unsigned primary key auto_increment,
    `application_id` mediumint unsigned not null,
    `interview_datetime` datetime not null,
    `result` enum('Pending', 'Passed', 'Failed') not null default 'Pending',
    foreign key(`application_id`) references application(`application_id`)
);