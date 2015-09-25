<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/dat.gui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/stats.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/render/WebGLDeferredRenderer.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/render/ShaderDeferred.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/render/RenderPass.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/render/EffectComposer.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/render/CopyShader.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/render/ShaderPass.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/render/FXAAShader.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/render/MaskPass.js"></script>

    <title>Insert title here</title>
    <style>
        body {
            /* set margin to 0 and overflow to hidden, to go fullscreen */
            margin: 0;
            overflow: hidden;
        }
    </style>

    <script type="text/javascript">

        var camera;

        $(function () {

            var stats = initStats();
            // 创建场景
            var scene = new THREE.Scene();

            // 创建透视相机
            camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
            // 设置相机位置
            camera.position.set(20, 30, 21);
            // 旋转相机对象
            camera.lookAt(new THREE.Vector3(0, 0, -30));
            scene.add(camera);

            // 创建平面光源需要使用的渲染器
            var renderer = new THREE.WebGLDeferredRenderer({
                width: window.innerWidth,
                height: window.innerHeight,
                scale: 1, antialias: true,
                tonemapping: THREE.FilmicOperator, brightness: 2.5
            });


            // 创建平面
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(70, 70, 1, 1),
                new THREE.MeshPhongMaterial({ color: 0xffffff, specular: 0xffffff, shininess: 200 })
            );
            // 设置平面旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置平面位置
            plane.position.set(0, 0, 0);
            scene.add(plane);


            $("#WebGL-output").append(renderer.domElement);

            var step = 0;

            // 创建聚光
            var spotLight0 = new THREE.SpotLight(0xcccccc);
            // 设置聚光位置
            spotLight0.position.set(-40, 60, -10);
            // 设置聚光默认灯光强度
            spotLight0.intensity = 0.1;
            // 设置聚光旋转对象
            spotLight0.lookAt(plane);
            scene.add(spotLight0);


            // 创建面光（光的颜色， 光的强度）
            var areaLight1 = new THREE.AreaLight(0xff0000, 3);
            // 设置面光位置
            areaLight1.position.set(-10, 10, -35);
            // 设置面光旋转
            areaLight1.rotation.set(-Math.PI / 2, 0, 0);
            // 设置宽度
            areaLight1.width = 4;
            // 设置高度
            areaLight1.height = 9.9;
            scene.add(areaLight1);

            // 创建面光（光的颜色， 光的强度）
            var areaLight2 = new THREE.AreaLight(0x00ff00, 3);
            areaLight2.position.set(0, 10, -35);
            areaLight2.rotation.set(-Math.PI / 2, 0, 0);
            areaLight2.width = 4;
            areaLight2.height = 9.9;
            scene.add(areaLight2);

            // 创建面光（光的颜色， 光的强度）
            var areaLight3 = new THREE.AreaLight(0x0000ff, 3);
            areaLight3.position.set(10, 10, -35);
            areaLight3.rotation.set(-Math.PI / 2, 0, 0);
            areaLight3.width = 4;
            areaLight3.height = 9.9;
            scene.add(areaLight3);

            // 创建平面
            var planeGeometry1 = new THREE.CubeGeometry(4, 10, 0);
            var planeGeometry1Mat = new THREE.MeshBasicMaterial({color: 0xff0000});
            var plane1 = new THREE.Mesh(planeGeometry1, planeGeometry1Mat);
            // 设置位置
            plane1.position = areaLight1.position;
            scene.add(plane1);

            // 创建平面
            var planeGeometry2 = new THREE.CubeGeometry(4, 10, 0);
            var planeGeometry2Mat = new THREE.MeshBasicMaterial({color: 0x00ff00});
            var plane2 = new THREE.Mesh(planeGeometry2, planeGeometry2Mat);

            plane2.position = areaLight2.position;
            scene.add(plane2);

            // 创建平面
            var planeGeometry3 = new THREE.CubeGeometry(4, 10, 0);
            var planeGeometry3Mat = new THREE.MeshBasicMaterial({color: 0x0000ff});
            var plane3 = new THREE.Mesh(planeGeometry3, planeGeometry3Mat);

            plane3.position = areaLight3.position;
            scene.add(plane3);


            var controls = new function () {
                this.rotationSpeed = 0.02;
                this.color1 = 0xff0000;
                this.intensity1 = 2;
                this.color2 = 0x00ff00;
                this.intensity2 = 2;
                this.color3 = 0x0000ff;
                this.intensity3 = 2;
            }


            var gui = new dat.GUI();
            gui.addColor(controls, "color1").onChange(function (e) {
                areaLight1.color = new THREE.Color(e);
                planeGeometry1Mat.color = new THREE.Color(e);
                scene.remove(plane1);
                plane1 = new THREE.Mesh(planeGeometry1, planeGeometry1Mat);
                plane1.position = areaLight1.position;
                scene.add(plane1);
            });
            gui.add(controls, "intensity1", 0, 5).onChange(function (e) {
                areaLight1.intensity = e;
            });

            gui.addColor(controls, "color2").onChange(function (e) {
                areaLight2.color = new THREE.Color(e);
                planeGeometry2Mat.color = new THREE.Color(e);
                scene.remove(plane2);
                plane2 = new THREE.Mesh(planeGeometry2, planeGeometry2Mat);
                plane2.position = areaLight2.position;
                scene.add(plane2);
            });
            gui.add(controls, "intensity2", 0, 5).onChange(function (e) {
                areaLight2.intensity = e;
            });

            gui.addColor(controls, "color3").onChange(function (e) {
                areaLight3.color = new THREE.Color(e);
                planeGeometry3Mat.color = new THREE.Color(e);
                scene.remove(plane3);
                plane3 = new THREE.Mesh(planeGeometry3, planeGeometry3Mat);
                plane3.position = areaLight3.position;
                scene.add(plane3);
            });
            gui.add(controls, "intensity3", 0, 5).onChange(function (e) {
                areaLight3.intensity = e;
            });

            render();

            function render() {
                stats.update();
                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            function initStats() {
                var stats = new Stats();
                stats.setMode(0);
                stats.domElement.style.position = "absolute";
                stats.domElement.style.left = "0px";
                stats.domElement.style.top = "0px";
                $("#Stats-output").append(stats.domElement);
                return stats;
            }
        });

    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>