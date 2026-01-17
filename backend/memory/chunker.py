from langchain.text_splitter import RecursiveCharacterTextSplitter
from typing import List

class MemoryChunker:
    def __init__(self, chunk_size: int = 1500, chunk_overlap: int = 200):
        self.splitter = RecursiveCharacterTextSplitter(
            chunk_size=chunk_size,
            chunk_overlap=chunk_overlap,
            length_function=len,
            separators=["\n\n", "\n", " ", ""]
        )

    def chunk_text(self, text: str) -> List[str]:
        """Split text into manageable chunks for AI processing and vector storage."""
        return self.splitter.split_text(text)
