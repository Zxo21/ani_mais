-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Tempo de geração: 04-Dez-2023 às 00:17
-- Versão do servidor: 8.0.31
-- versão do PHP: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `animais`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `animal`
--

DROP TABLE IF EXISTS `animal`;
CREATE TABLE IF NOT EXISTS `animal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `dataNasc` date DEFAULT NULL,
  `raca` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `genero` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `numChip` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `foto` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `animal`
--

INSERT INTO `animal` (`id`, `nome`, `dataNasc`, `raca`, `genero`, `numChip`, `foto`) VALUES
(1, 'Layca', '2002-12-25', 'Pastor Alemão', 'Fêmea', '5896471254', 'assets/perfil/layca01.jpg');

-- --------------------------------------------------------

--
-- Estrutura da tabela `animal_comorbidade`
--

DROP TABLE IF EXISTS `animal_comorbidade`;
CREATE TABLE IF NOT EXISTS `animal_comorbidade` (
  `animalid` int NOT NULL,
  `comorbidadeid` int NOT NULL,
  PRIMARY KEY (`animalid`,`comorbidadeid`),
  KEY `comorbidadeid` (`comorbidadeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `animal_comorbidade`
--

INSERT INTO `animal_comorbidade` (`animalid`, `comorbidadeid`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `animal_vacinacao`
--

DROP TABLE IF EXISTS `animal_vacinacao`;
CREATE TABLE IF NOT EXISTS `animal_vacinacao` (
  `animalid` int NOT NULL,
  `vacinacaoid` int NOT NULL,
  PRIMARY KEY (`vacinacaoid`,`animalid`),
  KEY `animalid` (`animalid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `animal_vacinacao`
--

INSERT INTO `animal_vacinacao` (`animalid`, `vacinacaoid`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `comorbidade`
--

DROP TABLE IF EXISTS `comorbidade`;
CREATE TABLE IF NOT EXISTS `comorbidade` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `comorbidade`
--

INSERT INTO `comorbidade` (`id`, `nome`, `descricao`, `observacao`) VALUES
(1, 'Sarda Canina', 'uma doença na pele (cutânea) que causa coceira intensa, feridas e até infecções.', 'Essa doença começou desde que a Layca nasceu');

-- --------------------------------------------------------

--
-- Estrutura da tabela `comorbidade_medicacao`
--

DROP TABLE IF EXISTS `comorbidade_medicacao`;
CREATE TABLE IF NOT EXISTS `comorbidade_medicacao` (
  `comorbidadeid` int NOT NULL,
  `medicacaoid` int NOT NULL,
  PRIMARY KEY (`comorbidadeid`,`medicacaoid`),
  KEY `medicacaoid` (`medicacaoid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `comorbidade_medicacao`
--

INSERT INTO `comorbidade_medicacao` (`comorbidadeid`, `medicacaoid`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicacao`
--

DROP TABLE IF EXISTS `medicacao`;
CREATE TABLE IF NOT EXISTS `medicacao` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `dosagem` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posologia` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `medicacao`
--

INSERT INTO `medicacao` (`id`, `nome`, `dosagem`, `posologia`, `observacao`) VALUES
(1, 'Carrapaticida Triatox MSD', 'Diluir 4 mL do produto Triatox em 1 litro de água', '1x ao dia', 'Usar somente quando a sarna estiver atacada');

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `senha` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `vacinacao`
--

DROP TABLE IF EXISTS `vacinacao`;
CREATE TABLE IF NOT EXISTS `vacinacao` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `dose` int NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `proxDose` date DEFAULT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `vacinacao`
--

INSERT INTO `vacinacao` (`id`, `nome`, `dose`, `descricao`, `proxDose`, `observacao`) VALUES
(1, 'V8', 1, 'Dose única', NULL, NULL);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
