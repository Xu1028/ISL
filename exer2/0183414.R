#10
library(ISLR)
summary(Weekly)
pairs(Weekly)
cor(Weekly[,-9])
#Year和Volume具有相关性
#10.b
glm.fit = glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data = Weekly, family = binomial)
summary(glm.fit)
#lag2是显著的
#10.c
glm.probs = predict(glm.fit, type = "response")
glm.pred = rep("Down", length(glm.probs))
glm.pred[glm.probs>0.5]="Up"
table(glm.pred,Direction)
mean(glm.pred==Direction)
#混淆矩阵的预测准确率为0.56
#10.d
train=(Year<2009)
Weekly.0910=Weekly[!train,]
glm.fit=glm(Direction~Lag2,data=Weekly,family=binomial,subset=train)
glm.probs=predict(glm.fit,Weekly.0910,type="response")
glm.pred=rep("Down",length(glm.probs))
glm.pred[glm.probs>0.5]="Up"
Direction.0910=Direction[!train]
table(glm.pred,Direction.0910)
mean(glm.pred==Direction.0910)
#准确率为0.625
#10.e
library(MASS)
lda.fit=lda(Direction~Lag2,data=Weekly,subset=train)
lda.pred=predict(lda.fit,Weekly.0910)
table(lda.pred$class,Direction.0910)
mean(lda.pred$class == Direction.0910)
#准确率为0/625
#10.f
qda.fit=qda(Direction~Lag2,data=Weekly,subset=train)
qda.class=predict(qda.fit,Weekly.0910)$class
table(qda.class,Direction.0910)
mean(qda.class==Direction.0910)
#准确率为0.59
#10.g
library(class)
train.X=as.matrix(Lag2[train])
test.X=as.matrix(Lag2[!train])
train.Direction=Direction[train]
set.seed(1)
knn.pred=knn(train.X,test.X,train.Direction,k=1)
table(knn.pred,Direction.0910)
mean(knn.pred==Direction.0910)
#准确率为0.5
#10.h 逻辑斯蒂回归和LDA结果最好
#10.i
#逻辑斯蒂回归
glm.fit=glm(Direction~Lag2:Lag1,data=Weekly,family=binomial,subset=train)
glm.probs=predict(glm.fit,Weekly.0910,type="response")
glm.pred=rep("Down",length(glm.probs))
glm.pred[glm.probs>0.5]="Up"
Direction.0910=Direction[!train]
table(glm.pred,Direction.0910)
mean(glm.pred==Direction.0910)
#LDA
lda.fit=lda(Direction~Lag2:Lag1,data=Weekly,subset=train)
lda.pred=predict(lda.fit,Weekly.0910)
table(lda.pred$class,Direction.0910)
mean(lda.pred$class==Direction.0910)
#QDA
qda.fit=qda(Direction~Lag2+sqrt(abs(Lag2)),data=Weekly,subset=train)
qda.class=predict(qda.fit,Weekly.0910)$class
table(qda.class,Direction.0910)
mean(qda.class==Direction.0910)
#K=10
knn.pred=knn(train.X,test.X,train.Direction,k=10)
table(knn.pred,Direction.0910)
mean(knn.pred==Direction.0910)
#K=100
knn.pred=knn(train.X,test.X,train.Direction,k=100)
table(knn.pred,Direction.0910)
mean(knn.pred==Direction.0910)
#最好的方法是逻辑斯蒂回归

#11.a
library(ISLR)
attach(Auto)
mpg01=rep(0,length(mpg))
mpg01[mpg>median(mpg)]=1
Auto=data.frame(Auto,mpg01)
#11.b
pairs(Auto)
#cylinders, weight, displacement, horsepower 有很大的可能相关
#11.c
train=(year%%2==0)
test=!train
Auto.train=Auto[train,]
Auto.test=Auto[test,]
mpg01.test=mpg01[test]
#11.d
library(MASS)
lda.fit=lda(mpg01~cylinders+weight+displacement+horsepower,data=Auto,subset=train)
lda.pred=predict(lda.fit,Auto.test)
mean(lda.pred$class!=mpg01.test)
#测试误差为0.126
#11.e
qda.fit=qda(mpg01~cylinders+weight+displacement+horsepower,data=Auto,subset=train)
qda.pred=predict(qda.fit,Auto.test)
mean(qda.pred$class!=mpg01.test)
#测试误差为0.132
#11.f
glm.fit=glm(mpg01~cylinders+weight+displacement+horsepower,data=Auto,family=binomial,subset=train)
glm.probs=predict(glm.fit,Auto.test,type="response")
glm.pred=rep(0,length(glm.probs))
glm.pred[glm.probs>0.5]=1
mean(glm.pred!=mpg01.test)
#测试误差为0.121
#11.g
library(class)
train.X=cbind(cylinders,weight,displacement,horsepower)[train,]
test.X=cbind(cylinders,weight,displacement,horsepower)[test,]
train.mpg01=mpg01[train]
set.seed(1)
#k=1
knn.pred=knn(train.X,test.X,train.mpg01,k=1)
mean(knn.pred != mpg01.test)
#k=5
knn.pred=knn(train.X,test.X,train.mpg01,k=5)
mean(knn.pred != mpg01.test)
#k=10
knn.pred=knn(train.X,test.X,train.mpg01,k=10)
mean(knn.pred != mpg01.test)
#k=5时时KNN 在数据集上效果最好