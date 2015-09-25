<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath }/js/three.js" ></script>
    <script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery-1.11.2.js" ></script>
    <title>Insert title here</title>

    <script type="text/javascript">


        function init() {

            // 渲染器将和Canvas元素进行绑定，如果之前在HTML中手动定义了id为mainCanvas的Canvas元素，那么Renderer可以这样写
            var renderer = new THREE.WebGLRenderer({
                canvas : document.getElementById("minCanvas")
            });

            // 如果想要Three.js生成Canvas元素，在HTML中就不需要定义Canvas元素，在JavaScript代码中可以这样写
            var renderer = new THREE.WebGLRenderer();// 创建3D渲染器

            renderer.setSize(400, 300);// 设置宽度高度
    //        document.getElementsByTagName('body')[0].appendChild(renderer.domElement);// 将元素添加到body中

            // 将3D场景添加到body元素
            document.body.appendChild(renderer.domElement);
            // 使用下面的代码将背景色（用于清除画面的颜色）设置为黑色
            renderer.setClearColor(0x000000);

            // 创建场景
            var scene = new THREE.Scene();

            // 定义一个一直透视投影的照相机
            var camera = new THREE.ParametricGeometry(45, 4/3, 1, 1000);
            camera.position.set(0,0,5);// 设置绝对位置
            scene.add(camera);// 添加到场景

            // 要创建一个x、y、z方向长度分别为1、2、3的长方体，并将其设置为红色
            var cube = new THREE.Mesh(new THEE.CubeGeometry(1,2,3),
                new THEE.MeshBasicMaterial({
                    color:0xff000
                })
            );
        }
    </script>

</head>
<body onload="init()">

    <canvas class="" id="minCanvas" width="400px;" height="300px;"></canvas>

</body>
</html>