CREATE SCHEMA amazon_reviews;
USE amazon_reviews;
CREATE TABLE reviews(
    Id INT PRIMARY KEY, 
    ProductId VARCHAR(255), 
    UserId VARCHAR(255), 
    ProfileName VARCHAR(255), 
    HelpfulnessNumerator INT,
    HelpfulnessDenominator INT, 
    Score INT, 
    Time BIGINT, 
    Summary TEXT, 
    Text TEXT -- Full review text
);

SHOW VARIABLES LIKE 'local_infile';

# import the data using local infile
LOAD DATA LOCAL INFILE 'C:\\Users\\14257\\OneDrive\\Desktop\\Github Projects\\NLP projects\\archive (8)\\Reviews.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM reviews
LIMIT 10;

## Create a function to count positive words in each review
USE yelp_data;
DELIMITER //

-- Function to count positive words
CREATE FUNCTION count_pos(text_input TEXT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE pos_word_count INT DEFAULT 0;
    
    -- Remove punctuation and normalize input
    SET text_input = REGEXP_REPLACE(text_input, '[[:punct:]]', ' ');
    SET text_input = TRIM(LOWER(text_input));
    
    SELECT COUNT(*)
    INTO pos_word_count
    FROM pos_words
    WHERE CONCAT(' ', text_input, ' ') LIKE CONCAT('% ', word, ' %');

    RETURN pos_word_count;
END //

DELIMITER ;

DELIMITER //

-- Function to count negative words
CREATE FUNCTION count_neg(text_input TEXT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE neg_word_count INT DEFAULT 0;

    -- Remove punctuation and normalize input
    SET text_input = REGEXP_REPLACE(text_input, '[[:punct:]]', ' ');
    SET text_input = TRIM(LOWER(text_input));

    SELECT COUNT(*)
    INTO neg_word_count
    FROM neg_words
    WHERE CONCAT(' ', text_input, ' ') LIKE CONCAT('% ', word, ' %');

    RETURN neg_word_count;
END //

DELIMITER ;


-- CREATE SENTIMENT COLUMN
USE amazon_reviews;
SELECT 
    Id, 
    `Text`, 
    ProductId,
    yelp_data.count_pos(Text) AS pos_count,
    yelp_data.count_neg(Text) AS neg_count,
    IF((yelp_data.count_pos(Text) + yelp_data.count_neg(Text)) = 0, NULL, 
       (yelp_data.count_pos(Text) - yelp_data.count_neg(Text)) / 
       (yelp_data.count_pos(Text) + yelp_data.count_neg(Text))) AS sentiment
FROM reviews
LIMIT 10;


SELECT 
    Id,
    `Text`,
    ProductId,
    Score,  -- Actual score from the customer
    -- Calculate positive and negative word counts
    yelp_data.count_pos(Text) AS positive_count,
    yelp_data.count_neg(Text) AS negative_count,
    -- Calculate sentiment from word counts
    (yelp_data.count_pos(Text) - yelp_data.count_neg(Text)) / (yelp_data.count_pos(Text) + yelp_data.count_neg(Text)) AS sentiment_score,
    -- Map the sentiment score to sentiment category
    CASE
        WHEN (yelp_data.count_pos(Text) - yelp_data.count_neg(Text)) / (yelp_data.count_pos(Text) + yelp_data.count_neg(Text)) > 0 THEN 'Positive'
        WHEN (yelp_data.count_pos(Text) - yelp_data.count_neg(Text)) / (yelp_data.count_pos(Text) + yelp_data.count_neg(Text)) < 0 THEN 'Negative'
        ELSE 'Neutral'
    END AS sentiment_category,
    -- Map customer score to sentiment category
    CASE
        WHEN Score <= 2 THEN 'Negative'
        WHEN Score = 3 THEN 'Neutral'
        WHEN Score >= 4 THEN 'Positive'
    END AS customer_sentiment,
    -- Compare sentiment category with customer sentiment
    CASE
        WHEN 
            CASE 
                WHEN (yelp_data.count_pos(Text) - yelp_data.count_neg(Text)) / (yelp_data.count_pos(Text) + yelp_data.count_neg(Text)) > 0 THEN 'Positive'
                WHEN (yelp_data.count_pos(Text) - yelp_data.count_neg(Text)) / (yelp_data.count_pos(Text) + yelp_data.count_neg(Text)) < 0 THEN 'Negative'
                ELSE 'Neutral'
            END = 
            CASE
                WHEN Score <= 2 THEN 'Negative'
                WHEN Score = 3 THEN 'Neutral'
                WHEN Score >= 4 THEN 'Positive'
            END THEN 'Match'
        ELSE 'Mismatch'
    END AS sentiment_match
FROM amazon_reviews.reviews
LIMIT 10;


#######################################



SELECT 
    (COUNT(CASE
                WHEN 
                    sentiment_from_text > 0 AND sentiment_from_score = 'Positive'
                    OR sentiment_from_text < 0 AND sentiment_from_score = 'Negative'
                    OR sentiment_from_text = 0 AND sentiment_from_score = 'Neutral'
                THEN 1
                ELSE NULL
            END) / COUNT(*) * 100) AS sentiment_match_percentage
FROM (
    SELECT 
        id, 
        Text,
        Score,
        (yelp_data.count_pos(Text) - yelp_data.count_neg(Text)) / (yelp_data.count_pos(Text) + yelp_data.count_neg(Text)) AS sentiment_from_text,
        CASE 
            WHEN Score <= 2 THEN 'Negative'
            WHEN Score = 3 THEN 'Neutral'
            WHEN Score >= 4 THEN 'Positive'
        END AS sentiment_from_score
    FROM amazon_reviews.reviews
    LIMIT 5000
) AS sentiment_comparison;




