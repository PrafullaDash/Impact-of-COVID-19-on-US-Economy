-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema depa_final_project
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema depa_final_project
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `depa_final_project` DEFAULT CHARACTER SET utf8 ;
USE `depa_final_project` ;

-- -----------------------------------------------------
-- Table `depa_final_project`.`calendar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`calendar` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`calendar` (
  `date_id` BIGINT NOT NULL,
  `date` DATE NOT NULL,
  `timestamp` BIGINT(20) NULL DEFAULT NULL,
  `weekend` VARCHAR(20) NULL,
  `day_of_week` VARCHAR(20) NULL,
  `month` VARCHAR(20) NULL,
  `monthday` INT NULL,
  `year` YEAR NULL,
  PRIMARY KEY (`date_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Industry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`industry` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`industry` (
  `industry_id` INT NOT NULL AUTO_INCREMENT,
  `naics_code` VARCHAR(20) NOT NULL,
  `industry_title` VARCHAR(50) NULL,
  `create_date` DATETIME NOT NULL,
  `last_modified_date` DATETIME NOT NULL,
  `is_active` VARCHAR(5) NULL,
  PRIMARY KEY (`industry_id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Code_UNIQUE` ON `depa_final_project`.`industry` (`naics_code` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Employment_Industry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`employment_industry` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`employment_industry` (
  `employment_industry_id` INT NOT NULL AUTO_INCREMENT,
  `date_id` BIGINT NOT NULL,
  `industry_id` INT NOT NULL,
  `persons_employed` BIGINT NULL,
  `change_prev_month_percent` DECIMAL(5,2) NULL,
  `change_prev_month_number` BIGINT NULL,
  PRIMARY KEY (`employment_industry_id`),
  CONSTRAINT `fk_Employment_Industry_Date1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project`.`calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employment_Industry_Industry1`
    FOREIGN KEY (`industry_id`)
    REFERENCES `depa_final_project`.`industry` (`industry_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Employment_Industry_Date1_idx` ON `depa_final_project`.`employment_industry` (`date_id` ASC) ;

CREATE INDEX `fk_Employment_Industry_Industry1_idx` ON `depa_final_project`.`employment_industry` (`industry_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Sector`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`sector` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`sector` (
  `sector_id` INT NOT NULL AUTO_INCREMENT,
  `sector_name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`sector_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Employment_Private_Sector`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`employment_private_sector` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`employment_private_sector` (
  `employment_private_sector_id` INT NOT NULL AUTO_INCREMENT,
  `date_id` BIGINT NOT NULL,
  `sector_id` INT NOT NULL,
  `persons_employed` BIGINT NULL,
  `change_prev_month_percent` DECIMAL(5,2) NULL,
  `change_prev_month_number` BIGINT NULL,
  PRIMARY KEY (`employment_private_sector_id`),
  CONSTRAINT `fk_Employment_Private_Sector_Date1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project`.`calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employment_Private_Sector_Sector1`
    FOREIGN KEY (`sector_id`)
    REFERENCES `depa_final_project`.`sector` (`sector_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Employment_Private_Sector_Date1_idx` ON `depa_final_project`.`employment_private_sector` (`date_id` ASC) ;

CREATE INDEX `fk_Employment_Private_Sector_Sector1_idx` ON `depa_final_project`.`employment_private_sector` (`sector_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Retail_Breakdown_NAICS_Code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`retail_breakdown_naics_code` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`retail_breakdown_naics_code` (
  `retail_industry_id` INT NOT NULL AUTO_INCREMENT,
  `naics_code` VARCHAR(20) NOT NULL,
  `industry_title` VARCHAR(200) NULL,
  `create_date` DATETIME NOT NULL,
  `last_modified_Date` DATETIME NOT NULL,
  `is_active` VARCHAR(5) NULL,
  PRIMARY KEY (`retail_industry_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Retail_Data_Seasonal_Adjusted`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`retail_data_seasonal_adjusted` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`retail_data_seasonal_adjusted` (
  `retail_seasonal_adjusted_id` INT NOT NULL AUTO_INCREMENT,
  `date_id` BIGINT NOT NULL,
  `retail_industry_id` INT NOT NULL,
  `sales` BIGINT NULL,
  `inventory` BIGINT NULL,
  `inventory_sales_ratio` DECIMAL(3,2) NULL,
  PRIMARY KEY (`retail_seasonal_adjusted_id`),
  CONSTRAINT `fk_Retai_Data_Seasonal_Adjusted_Date1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project`.`calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Retail_Data_Seasonal_Adjusted_Retail_Breakdown_NAICS_Code1`
    FOREIGN KEY (`retail_industry_id`)
    REFERENCES `depa_final_project`.`retail_breakdown_naics_code` (`retail_industry_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Retai_Data_Seasonal_Adjusted_Date1_idx` ON `depa_final_project`.`retail_data_seasonal_adjusted` (`date_id` ASC) ;

CREATE INDEX `fk_Retail_Data_Seasonal_Adjusted_Retail_Breakdown_NAICS_Cod_idx` ON `depa_final_project`.`retail_data_seasonal_adjusted` (`retail_industry_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Covid19_US`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`covid19_us` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`covid19_us` (
  `fips` INT NOT NULL,
  `province_state` VARCHAR(45) NOT NULL,
  `country_region` VARCHAR(45) NOT NULL,
  `confirmed` INT NULL,
  `deaths` INT NULL,
  `recovered` INT NULL,
  `active` INT NULL,
  `incident_Rate` FLOAT NULL,
  `people_Tested` INT NULL,
  `people_Hospitalized` INT NULL,
  `mortality_rate` FLOAT NULL,
  `uid` INT NULL,
  `ISO3` VARCHAR(45) NULL,
  `testing_rate` FLOAT NULL,
  `hospitalization_rate` FLOAT NULL,
  PRIMARY KEY (`fips`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Covid19_Time_Series_US`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`covid19_time_series_us` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`covid19_time_series_us` (
  `covid19_time_series_us_id` INT NOT NULL AUTO_INCREMENT,
  `date_id` BIGINT NOT NULL,
  `confirmed_cases` BIGINT NOT NULL,
  PRIMARY KEY (`covid19_time_series_us_id`),
  CONSTRAINT `fk_Covid19_time_series_us_Date1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project`.`calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Covid19_time_series_us_Date1_idx` ON `depa_final_project`.`covid19_time_series_us` (`date_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project`.`SP500_Stock_Data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`sp500_stock_data` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`sp500_stock_data` (
  `stock_data_id` INT NOT NULL AUTO_INCREMENT,
  `date_id` BIGINT NOT NULL,
  `open` FLOAT NULL,
  `high` FLOAT NULL,
  `low` FLOAT NULL,
  `close` FLOAT NULL,
  `adj_close` FLOAT NULL,
  `volume` BIGINT NULL,
  PRIMARY KEY (`stock_data_id`),
  CONSTRAINT `fk_SNP_Date1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project`.`calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_SNP_Date1_idx` ON `depa_final_project`.`sp500_stock_data` (`date_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Organization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`organization` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`organization` (
  `organization_id` INT NOT NULL AUTO_INCREMENT,
  `industry_id` INT NOT NULL,
  `code` VARCHAR(5) NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`organization_id`),
  CONSTRAINT `fk_Organization_Industry1`
    FOREIGN KEY (`industry_id`)
    REFERENCES `depa_final_project`.`industry` (`industry_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Organization_Industry1_idx` ON `depa_final_project`.`organization` (`industry_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project`.`Organization_Stock_Data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`organization_stock_data` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`organization_stock_data` (
  `organization_stock_data_id` INT NOT NULL AUTO_INCREMENT,
  `organization_id` INT NOT NULL,
  `date_id` BIGINT NOT NULL,
  `open` FLOAT NULL,
  `high` FLOAT NULL,
  `low` FLOAT NULL,
  `close` FLOAT NULL,
  `adj_close` FLOAT NULL,
  `volume` BIGINT NULL,
  PRIMARY KEY (`organization_stock_data_id`),
  CONSTRAINT `fk_Organization_Stock_Data_Organization1`
    FOREIGN KEY (`organization_id`)
    REFERENCES `depa_final_project`.`organization` (`organization_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Organization_Stock_Data_Date1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project`.`calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Organization_Stock_Data_Organization1_idx` ON `depa_final_project`.`organization_stock_data` (`organization_id` ASC);

CREATE INDEX `fk_Organization_Stock_Data_Date1_idx` ON `depa_final_project`.`organization_stock_data` (`date_id` ASC);


-- -----------------------------------------------------
-- Table `depa_final_project`.`numbers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`numbers` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`numbers` (
  `number` BIGINT(20) NULL DEFAULT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depa_final_project`.`numbers_small`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project`.`numbers_small` ;

CREATE TABLE IF NOT EXISTS `depa_final_project`.`numbers_small` (
  `number` INT(11) NULL DEFAULT NULL)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
