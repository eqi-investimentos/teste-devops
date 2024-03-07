#VPC

resource "aws_vpc" "vpc_deveqi" {
  cidr_block = "10.0.0.0/21"


  tags = {
    Name = "vpc_deveqi"
  }
}

#Subnets públicas

resource "aws_subnet" "deveqi-public-a" {
  vpc_id            = aws_vpc.vpc_deveqi.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "deveqi-public-a"
  }
}



resource "aws_subnet" "deveqi-public-b" {
  vpc_id            = aws_vpc.vpc_deveqi.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "deveqi-public-b"
  }
}



#Subnets privadas

resource "aws_subnet" "deveqi-private-a" {
  vpc_id            = aws_vpc.vpc_deveqi.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "deveqi-private-a"
  }
}



resource "aws_subnet" "deveqi-private-b" {
  vpc_id            = aws_vpc.vpc_deveqi.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "deveqi-private-b"
  }
}



#Internet Gateway

resource "aws_internet_gateway" "ig-deveqi" {
  vpc_id = aws_vpc.vpc_deveqi.id

  tags = {
    Name = "ig_deveqi"
  }
}


# Associação do Internet Gateway à tabela de roteamento pública

resource "aws_route_table" "deveqi-rtpublic" {
  vpc_id = aws_vpc.vpc_deveqi.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-deveqi.id
  }

  tags = {
    Name = "deveqi-public-route"
  }
}


#Associações de tabelas de roteamento para subnets públicas

resource "aws_route_table_association" "rta-deveqi-public-a" {
  subnet_id      = aws_subnet.deveqi-public-a.id
  route_table_id = aws_route_table.deveqi-rtpublic.id
}

resource "aws_route_table_association" "rta-deveqi-public-b" {
  subnet_id      = aws_subnet.deveqi-public-b.id
  route_table_id = aws_route_table.deveqi-rtpublic.id
}



#Tabelas de roteamento privadas

resource "aws_route_table" "deveqi-rtprivate" {
  vpc_id = aws_vpc.vpc_deveqi.id
  tags = {
    Name = "deveqi-rtprivate"
  }
}


#Associações de tabelas de roteamento para subnets 

resource "aws_route_table_association" "rta-deveqi-private-a" {
  subnet_id      = aws_subnet.deveqi-private-a.id
  route_table_id = aws_route_table.deveqi-rtprivate.id
}

resource "aws_route_table_association" "rta-deveqi-private-b" {
  subnet_id      = aws_subnet.deveqi-private-b.id
  route_table_id = aws_route_table.deveqi-rtprivate.id
}




#Security Group API 

resource "aws_security_group" "sg-deveqi" {
  name        = "sg_deveqi_api"
  description = "Security group that allows ssh/https and all egress traffic"
  vpc_id      = aws_vpc.vpc_deveqi.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.deveqi-private-a.cidr_block]

  }

  tags = {
    Name = "sg-deveqi-api"
  }
}

#Security group MongoDB

resource "aws_security_group" "mongodb" {
  name        = "mongodb"
  description = "sg mongob"
  vpc_id      = aws_vpc.vpc_deveqi.id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-deveqi.id]

  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_deveqi.cidr_block]

  }


  tags = {
    Name = "mongodb"
  }
}

