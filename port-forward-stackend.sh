#!/bin/bash

echo "🚀 Port forwarding Stackend to http://localhost:9000"
echo ""
echo "Stackend will be available at:"
echo "- API: http://localhost:9000"
echo "- Health: http://localhost:9000/health"
echo "- Docs: http://localhost:9000/docs (if available)"
echo ""
echo "Press Ctrl+C to stop"
echo ""

kubectl port-forward svc/stackend-test -n stackai-app 9000:8000

