# 二、坐标系与刚体的旋转变换

## 2.1 问题导入
车辆坡道行驶重力在各轴上的分量，影响驱动、制动、转向
### 2.1.1 纵坡
上下坡，只存在pitch，重力分力增大/减小驱动/制动加速度约束


### 2.3.7 欧拉角速度与刚体角速度的关系

$$ \left(\begin{array}{ccc} -\frac{\sin\left(\theta \right)}{\cos\left(\phi \right)\,{\cos\left(\theta \right)}^2+\cos\left(\phi \right)\,{\sin\left(\theta \right)}^2} & 0 & \frac{\cos\left(\theta \right)}{\cos\left(\phi \right)\,{\cos\left(\theta \right)}^2+\cos\left(\phi \right)\,{\sin\left(\theta \right)}^2}\\ \frac{\cos\left(\theta \right)}{{\cos\left(\theta \right)}^2+{\sin\left(\theta \right)}^2} & 0 & \frac{\sin\left(\theta \right)}{{\cos\left(\theta \right)}^2+{\sin\left(\theta \right)}^2}\\ \frac{\sin\left(\phi \right)\,\sin\left(\theta \right)}{\cos\left(\phi \right)\,{\cos\left(\theta \right)}^2+\cos\left(\phi \right)\,{\sin\left(\theta \right)}^2} & 1 & -\frac{\cos\left(\theta \right)\,\sin\left(\phi \right)}{\cos\left(\phi \right)\,{\cos\left(\theta \right)}^2+\cos\left(\phi \right)\,{\sin\left(\theta \right)}^2} \end{array}\right)=\left(\begin{array}{ccc} -\frac{\sin\left(\theta \right)}{\cos\left(\phi \right)} & 0 & \frac{\cos\left(\theta \right)}{\cos\left(\phi \right)}\\ \cos\left(\theta \right) & 0 & \sin\left(\theta \right)\\ \mathrm{tan}\left(\phi \right)\,\sin\left(\theta \right) & 1 & \cos\left(\theta \right)\,\mathrm{tan}\left(\phi \right) \end{array}\right) $$