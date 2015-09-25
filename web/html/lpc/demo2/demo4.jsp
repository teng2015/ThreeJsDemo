<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ConvexGeometry.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ParametricGeometries.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/dat.gui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/stats.js"></script>
    <title>Insert title here</title>

    <script type="text/javascript">

        $(function() {
            // 调用帧插件
            var stats = initStats();

            // 创建一个场景
            var scene = new THREE.Scene();

            // 创建一个相机  视场（推荐45度）,长宽比（推荐width/height）,近面（推荐0.1开始渲染）,远面（推荐1000）
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
            // 设置相机位置
            camera.position.set(-50, 30, 20);
            camera.lookAt(new THREE.Vector3(-10, 0, 0));

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            // 设置背景和透明度
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            // 设置宽度和高度
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 是否允许阴影映射
            renderer.shadowMapEnabled = true;


            // 创建立方体
            var planeGeometry = new THREE.PlaneGeometry(60, 40, 1, 1);
            var planeMaterial = new THREE.MeshLambertMaterial({color: 0xffffff});
            var plane = new THREE.Mesh(planeGeometry, planeMaterial);
            // 是否支持阴影覆盖
            plane.receiveShadow = true;
            // 设置立方体沿x旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置立方体位置
            plane.position.set(0, 0, 0);
            scene.add(plane);

            // 创建光源（环境光）
            var ambientLight = new THREE.AmbientLight(0x090909);
            scene.add(ambientLight);

            // 创建光源（聚光灯光源）
            var spotLight = new THREE.SpotLight( 0xffffff );
            spotLight.position.set( -40, 40, 50 );
            spotLight.castShadow = true;
            scene.add( spotLight );

            addGeometries(scene);

            $("#WebGL-output").append(renderer.domElement);


            var step = 0;

            render();

            // 自定义形状
            function addGeometries(scene) {
                var geom = [];
                geom.push(new THREE.CylinderGeometry(1, 4, 4));

                // 基础立方体
                geom.push(new THREE.CubeGeometry(2, 2, 2));
                console.log(new THREE.CubeGeometry(2, 2, 2));

                // 基础球形
                geom.push(new THREE.SphereGeometry(2));
                geom.push(new THREE.IcosahedronGeometry(4));

                // 创建点
                var points = [
                    new THREE.Vector3(2, 2, 2),
                    new THREE.Vector3(2, 2, -2),
                    new THREE.Vector3(-2, 2, -2),
                    new THREE.Vector3(-2, 2, 2),
                    new THREE.Vector3(2, -2, 2),
                    new THREE.Vector3(2, -2, -2),
                    new THREE.Vector3(-2, -2, -2),
                    new THREE.Vector3(-2, -2, 2)
                ];
                geom.push(new THREE.ConvexGeometry(points));

                var pts = [];
                var detail = .1;
                var radius = 3;

                for (var angle = 0.0; angle < Math.PI; angle += detail) {
                    pts.push(new THREE.Vector3(Math.cos(angle) * radius, 0, Math.sin(angle) * radius));
                }

                geom.push(new THREE.LatheGeometry(pts, 12));
                geom.push(new THREE.OctahedronGeometry(3));
                geom.push(new THREE.ParametricGeometry(THREE.ParametricGeometries.mobius3d, 20, 10));

                geom.push(new THREE.TetrahedronGeometry(3));

                geom.push(new THREE.TorusGeometry(3, 1, 10, 10));

                geom.push(new THREE.TorusKnotGeometry(3, 0.5, 50, 20));

                var j = 0;
                for (var i=0; i<geom.length; i++) {
                    var cubeMaterial = new THREE.MeshLambertMaterial({color: Math.random() * 0xffffff, wireframe: true});

                    var materials = [
                        new THREE.MeshLambertMaterial({color:Math.random() * 0xffffff, shading: THREE.FlatShading}),
                        new THREE.MeshBasicMaterial({color: 0x000000, wireframe: true})
                    ];

                    var mesh = THREE.SceneUtils.createMultiMaterialObject(geom[i], materials);
                    mesh.traverse(function(e) {e.castShadow = true});

                    mesh.position.x = -24 + ((i % 4) * 12);
                    mesh.position.y = 4;
                    mesh.position.z = -8 + (j*12);

                    if ((i + 1) % 4 == 0) {
                        j++;
                    }
                    scene.add(mesh);
                }
            }


            // 渲染
            function render() {
                stats.update();

                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            // 帧插件
            function initStats() {
                var stats = new Stats();
                stats.setMode(0);
                stats.domElement.style.position = 'absolute';
                stats.domElement.style.left = '0px';
                stats.domElement.style.top = '0px';

                $("#Stats-output").append( stats.domElement );
                return stats;
            }

        })



    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>