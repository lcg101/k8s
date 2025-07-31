#!/bin/bash

echo "🔄 Monitoring namespace 모든 컴포넌트 재시작 시작..."

# 1. Prometheus 재시작
echo "📊 Prometheus 재시작 중..."
kubectl rollout restart deployment prometheus-deployment -n monitoring

# 2. Grafana 재시작
echo "📈 Grafana 재시작 중..."
kubectl rollout restart deployment grafana -n monitoring

# 3. kube-state-metrics 재시작
echo "🔍 kube-state-metrics 재시작 중..."
kubectl rollout restart deployment kube-state-metrics -n monitoring

# 4. node-exporter 재시작 (DaemonSet)
echo "🖥️ node-exporter 재시작 중..."
kubectl rollout restart daemonset node-exporter -n monitoring

# 5. 재시작 완료 대기
echo "⏳ Pod 재시작 완료 대기 중..."
sleep 30

# 6. 모든 Pod 상태 확인
echo "✅ Pod 상태 확인 중..."
kubectl get pods -n monitoring

# 7. 서비스 상태 확인
echo "🔗 서비스 상태 확인 중..."
kubectl get svc -n monitoring

# 8. kube-state-metrics 로그 확인
echo "📋 kube-state-metrics 로그 확인 중..."
kubectl logs -n monitoring -l app=kube-state-metrics --tail=10

# 9. Prometheus 로그 확인
echo "📋 Prometheus 로그 확인 중..."
kubectl logs -n monitoring -l app=prometheus-server --tail=10

echo ""
echo "🎉 Monitoring 재시작 완료!"
echo ""
echo "📊 다음 명령으로 상태를 확인하세요:"
echo "kubectl get pods -n monitoring"
echo "kubectl port-forward svc/prometheus-service 9090:8080 -n monitoring"
echo ""
echo "🌐 접속 정보:"
echo "Grafana: http://$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}'):30004"
echo "Prometheus: http://$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}'):30003" 
