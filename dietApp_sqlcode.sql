-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema dietApp
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema dietApp
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dietApp` DEFAULT CHARACTER SET utf8 ;
USE `dietApp` ;

-- -----------------------------------------------------
-- Table `dietApp`.`country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`country` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`country` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `countryCode` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  UNIQUE INDEX `countryCode_UNIQUE` (`countryCode` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`users` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`users` (
  `id` INT NOT NULL,
  `userName` VARCHAR(50) NOT NULL,
  `firstName` VARCHAR(50) NULL,
  `lastName` VARCHAR(50) NULL,
  `email` VARCHAR(50) NULL,
  `password` VARCHAR(255) NULL,
  `state` VARCHAR(50) NULL,
  `countryId` INT NULL,
  `address` VARCHAR(50) NULL,
  `phone` VARCHAR(50) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `userName_UNIQUE` (`userName` ASC) VISIBLE,
  INDEX `fk_users_country_idx` (`countryId` ASC) VISIBLE,
  CONSTRAINT `fk_users_country`
    FOREIGN KEY (`countryId`)
    REFERENCES `dietApp`.`country` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`followers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`followers` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`followers` (
  `id` INT NOT NULL,
  `userId` INT NULL,
  `followerId` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_followers_users_idx` (`userId` ASC) VISIBLE,
  CONSTRAINT `fk_followers_users`
    FOREIGN KEY (`userId`)
    REFERENCES `dietApp`.`users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`allergies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`allergies` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`allergies` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`userAllergies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`userAllergies` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`userAllergies` (
  `id` INT NOT NULL,
  `userId` INT NULL,
  `allergyId` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`meals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`meals` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`meals` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`userMeals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`userMeals` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`userMeals` (
  `id` INT NOT NULL,
  `mealId` INT NULL,
  `userId` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`recipes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`recipes` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`recipes` (
  `id` INT NOT NULL,
  `userId` INT NULL,
  `name` VARCHAR(50) NULL,
  `description` VARCHAR(50) NULL,
  `ingredients` JSON NULL,
  `preparationSteps` TEXT(500) NULL,
  `likes` INT NULL,
  `images` JSON NULL,
  `video` VARCHAR(50) NULL,
  `sharedTimes` INT NULL,
  `views` INT NULL,
  `commentId` JSON NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`recipeTags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`recipeTags` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`recipeTags` (
  `id` INT NOT NULL,
  `tagId` INT NULL,
  `recipeId` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`tags` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`tags` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`userCusines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`userCusines` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`userCusines` (
  `id` INT NOT NULL,
  `userId` INT NULL,
  `cusineId` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dietApp`.`cusines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dietApp`.`cusines` ;

CREATE TABLE IF NOT EXISTS `dietApp`.`cusines` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
