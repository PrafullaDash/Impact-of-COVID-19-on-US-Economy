-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema depa_final_project_dw
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema depa_final_project_dw
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `depa_final_project_dw` DEFAULT CHARACTER SET utf8 ;
USE `depa_final_project_dw` ;

-- -----------------------------------------------------
-- Table `depa_final_project_dw`.`dim_calendar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project_dw`.`dim_calendar` ;

CREATE TABLE IF NOT EXISTS `depa_final_project_dw`.`dim_calendar` (
  `date_id` BIGINT NOT NULL,
  `date` DATE NULL,
  `timestamp` BIGINT(20) NULL,
  `weekend` VARCHAR(20) NULL,
  `day_of_week` VARCHAR(20) NULL,
  `month` VARCHAR(20) NULL,
  `month_day` INT NULL,
  `year` YEAR NULL,
  PRIMARY KEY (`date_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `depa_final_project_dw`.`dim_employment_industry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project_dw`.`dim_employment_industry` ;

CREATE TABLE IF NOT EXISTS `depa_final_project_dw`.`dim_employment_industry` (
  `employment_industry_id` INT NOT NULL,
  `date_id` BIGINT NOT NULL,
  `industry_id` INT NULL,
  `industry_title` VARCHAR(50) NULL,
  `persons_employed` BIGINT NULL,
  `change_prev_month_percent` DECIMAL(5,2) NULL,
  `change_prev_month_number` BIGINT NULL,
  PRIMARY KEY (`employment_industry_id`),
  CONSTRAINT `fk_dim_employment_industry_dim_calendar1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project_dw`.`dim_calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_dim_employment_industry_dim_calendar1_idx` ON `depa_final_project_dw`.`dim_employment_industry` (`date_id` ASC);


-- -----------------------------------------------------
-- Table `depa_final_project_dw`.`dim_retail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project_dw`.`dim_retail` ;

CREATE TABLE IF NOT EXISTS `depa_final_project_dw`.`dim_retail` (
  `retail_seasonal_adjusted_id` INT NOT NULL,
  `date_id` BIGINT NOT NULL,
  `retail_industry_id` INT NULL,
  `retail_industry_title` VARCHAR(200) NULL,
  `sales` BIGINT NULL,
  `inventory` BIGINT NULL,
  `inventory_sales_ratio` DECIMAL(3,2) NULL,
  PRIMARY KEY (`retail_seasonal_adjusted_id`),
  CONSTRAINT `fk_dim_retail_dim_calendar1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project_dw`.`dim_calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_dim_retail_dim_calendar1_idx` ON `depa_final_project_dw`.`dim_retail` (`date_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project_dw`.`dim_snp500_stock`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project_dw`.`dim_snp500_stock` ;

CREATE TABLE IF NOT EXISTS `depa_final_project_dw`.`dim_snp500_stock` (
  `snp500_stock_id` INT NOT NULL,
  `date_id` BIGINT NOT NULL,
  `open` FLOAT NULL,
  `high` FLOAT NULL,
  `low` FLOAT NULL,
  `close` FLOAT NULL,
  `adj_close` FLOAT NULL,
  `volume` BIGINT NULL,
  PRIMARY KEY (`snp500_stock_id`),
  CONSTRAINT `fk_dim_snp500_stock_dim_calendar1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project_dw`.`dim_calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_dim_snp500_stock_dim_calendar1_idx` ON `depa_final_project_dw`.`dim_snp500_stock` (`date_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project_dw`.`dim_organization_stock`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project_dw`.`dim_organization_stock` ;

CREATE TABLE IF NOT EXISTS `depa_final_project_dw`.`dim_organization_stock` (
  `organization_stock_id` INT NOT NULL,
  `date_id` BIGINT NOT NULL,
  `organization_name` VARCHAR(45) NULL,
  `industry_title` VARCHAR(45) NULL,
  `adj_close` FLOAT NULL,
  PRIMARY KEY (`organization_stock_id`),
  CONSTRAINT `fk_dim_organization_stock_dim_calendar1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project_dw`.`dim_calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_dim_organization_stock_dim_calendar1_idx` ON `depa_final_project_dw`.`dim_organization_stock` (`date_id` ASC) ;


-- -----------------------------------------------------
-- Table `depa_final_project_dw`.`fact_economy`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `depa_final_project_dw`.`fact_economy` ;

CREATE TABLE IF NOT EXISTS `depa_final_project_dw`.`fact_economy` (
  `economy_id` INT NOT NULL AUTO_INCREMENT,
  `employment_industry_id` INT NOT NULL,
  `date_id` BIGINT NOT NULL,
  `confirmed_covid_cases` BIGINT NULL,
  `retail_seasonal_adjusted_id` INT NOT NULL,
  `snp500_stock_id` INT NOT NULL,
  `organization_stock_id` INT NOT NULL,
  PRIMARY KEY (`economy_id`),
  CONSTRAINT `fk_fact_economy_dim_employment_industry`
    FOREIGN KEY (`employment_industry_id`)
    REFERENCES `depa_final_project_dw`.`dim_employment_industry` (`employment_industry_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_economy_dim_calendar1`
    FOREIGN KEY (`date_id`)
    REFERENCES `depa_final_project_dw`.`dim_calendar` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_economy_dim_retail1`
    FOREIGN KEY (`retail_seasonal_adjusted_id`)
    REFERENCES `depa_final_project_dw`.`dim_retail` (`retail_seasonal_adjusted_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_economy_dim_snp500_stock1`
    FOREIGN KEY (`snp500_stock_id`)
    REFERENCES `depa_final_project_dw`.`dim_snp500_stock` (`snp500_stock_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_economy_dim_organization_stock1`
    FOREIGN KEY (`organization_stock_id`)
    REFERENCES `depa_final_project_dw`.`dim_organization_stock` (`organization_stock_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_fact_economy_dim_employment_industry_idx` ON `depa_final_project_dw`.`fact_economy` (`employment_industry_id` ASC) ;

CREATE INDEX `fk_fact_economy_dim_calendar1_idx` ON `depa_final_project_dw`.`fact_economy` (`date_id` ASC) ;

CREATE INDEX `fk_fact_economy_dim_retail1_idx` ON `depa_final_project_dw`.`fact_economy` (`retail_seasonal_adjusted_id` ASC) ;

CREATE INDEX `fk_fact_economy_dim_snp500_stock1_idx` ON `depa_final_project_dw`.`fact_economy` (`snp500_stock_id` ASC) ;

CREATE INDEX `fk_fact_economy_dim_organization_stock1_idx` ON `depa_final_project_dw`.`fact_economy` (`organization_stock_id` ASC) ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
