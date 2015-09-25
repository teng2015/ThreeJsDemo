<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <title>Insert title here</title>

    <style>
        body{
            /* set margin to 0 and overflow to hidden, to go fullscreen */
            margin: 0;
            overflow: hidden;
        }
    </style>

    <script type="text/javascript">

        $(function() {

            // 创建场景
            var scene = new THREE.Scene();

            // 创建相机
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
            camera.position.set(-30, 40, 30);
            camera.lookAt(scene.position);
            scene.add(camera);

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 0.1);
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = true;// 阴影地图启用

            // 创建网格，并添加带颜色的平面
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(60, 20),
                new THREE.MeshLambertMaterial({
                    color: 0xffffff
                })
            );
            plane.rotation.x = -0.5 * Math.PI;
            plane.position.set(15, 0, 0);
            plane.receiveShadow = true;// 是否支持阴影覆盖
            scene.add(plane);

            // 创建立方体
            var cube = new THREE.Mesh(new THREE.CubeGeometry(4, 4, 4),
                new THREE.MeshLambertMaterial({
                    color: 0xff0000
                })
            );
            cube.castShadow = true;// 是否生成阴影
            cube.position.set(-4, 3, 0);
            scene.add(cube);

            var sphere = new THREE.Mesh(new THREE.SphereGeometry(4, 20, 20),
                new THREE.MeshLambertMaterial({
                    color: 0x7777ff
                })
            );
            sphere.castShadow = true;// 是否生成阴影
            sphere.position.set(20, 4, 2);
            scene.add(sphere);

            // 创建灯光、阴影
            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-40, 60, -10);
            spotLight.castShadow = true;
            scene.add(spotLight);// 是否生成阴影


            $("#WebGL-output").append(renderer.domElement);
            renderer.render(scene, camera);


        })

    </script>

</head>
<body>

    <div id="WebGL-output"></div>

</body>
</html>