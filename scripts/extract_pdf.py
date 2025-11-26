from pdfminer.high_level import extract_text
import sys
from pathlib import Path

pdf_path = Path('Practical-session-subject-Organisation-centric-coordination.pdf')
if not pdf_path.exists():
    print('PDF not found:', pdf_path)
    sys.exit(1)

text = extract_text(str(pdf_path))
out_path = Path('practical_session_extracted.txt')
out_path.write_text(text, encoding='utf-8')
print('Wrote extracted text to', out_path)
# Print first 2000 chars for quick preview
print('\n--- PREVIEW (first 2000 chars) ---\n')
print(text[:2000])
