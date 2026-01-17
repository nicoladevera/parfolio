import io
from typing import Optional
from pypdf import PdfReader
from docx import Document

class FileParser:
    @staticmethod
    def parse_pdf(file_content: bytes) -> str:
        """Extract text from PDF bytes."""
        buffer = io.BytesIO(file_content)
        reader = PdfReader(buffer)
        text = ""
        for page in reader.pages:
            content = page.extract_text()
            if content:
                text += content + "\n"
        return text

    @staticmethod
    def parse_docx(file_content: bytes) -> str:
        """Extract text from DOCX bytes."""
        buffer = io.BytesIO(file_content)
        doc = Document(buffer)
        return "\n".join([para.text for para in doc.paragraphs])

    @staticmethod
    def parse_text(file_content: bytes) -> str:
        """Extract text from plain text/markdown bytes."""
        return file_content.decode("utf-8")

    @classmethod
    def extract_text(cls, file_content: bytes, filename: str) -> Optional[str]:
        """Auto-detect file type and extract text."""
        ext = filename.split(".")[-1].lower()
        try:
            if ext == "pdf":
                return cls.parse_pdf(file_content)
            elif ext == "docx":
                return cls.parse_docx(file_content)
            elif ext in ["txt", "md"]:
                return cls.parse_text(file_content)
            else:
                return None
        except Exception as e:
            print(f"Error parsing file {filename}: {str(e)}")
            return None
