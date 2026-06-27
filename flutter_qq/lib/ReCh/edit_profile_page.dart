import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rech/ReCh/widget/appbar.dart';
import 'package:rech/services/api_service.dart';
import 'package:rech/states/app_state.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  int _gender = 0;
  final List<String> _tags = [];
  String? _avatarPath;
  String? _bannerPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppState>(context, listen: false).currentUser;
    if (user != null) {
      _nicknameController.text = user.nickname;
      _signatureController.text = user.signature;
      _ageController.text = user.age > 0 ? user.age.toString() : '';
      _gender = user.gender;
      _avatarPath = user.avatar.isNotEmpty ? user.avatar : null;
      _bannerPath = user.banner.isNotEmpty ? user.banner : null;
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _signatureController.dispose();
    _ageController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isAvatar) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isAvatar) {
          _avatarPath = image.path;
        } else {
          _bannerPath = image.path;
        }
      });
    }
  }

  Future<void> _onSave() async {
    setState(() => _isLoading = true);
    try {
      final data = <String, dynamic>{
        'nickname': _nicknameController.text.trim(),
        'signature': _signatureController.text.trim(),
        'gender': _gender,
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'tags': _tags.join(','),
        if (_avatarPath != null) 'avatar': _avatarPath,
        if (_bannerPath != null) 'banner': _bannerPath,
      };
      final response = await ApiService().updateProfile(data);
      if (response.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('保存成功')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  Widget _buildSection({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFC7C7CC)),
        filled: true,
        fillColor: const Color(0xFFF5F6F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: StudyAppBar.MyAppBar(
        '编辑资料',
        context,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF5F6F8),
              ),
              child: const BackButton(
                color: Color(0xFF1A1A1A),
                style: ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => _pickImage(true),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF5F6F8),
                        border: Border.all(
                          color: const Color(0xFFE5E5EA),
                        ),
                      ),
                      child: _avatarPath != null && _avatarPath!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                _avatarPath!,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt_outlined,
                              size: 28,
                              color: Color(0xFF8A8A8E),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('昵称', _nicknameController),
                const SizedBox(height: 16),
                _buildTextField('签名', _signatureController, maxLines: 3),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              children: [
                const Text(
                  '性别',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _GenderChip(
                      label: '男',
                      value: 1,
                      groupValue: _gender,
                      onChanged: (v) => setState(() => _gender = v),
                    ),
                    const SizedBox(width: 12),
                    _GenderChip(
                      label: '女',
                      value: 2,
                      groupValue: _gender,
                      onChanged: (v) => setState(() => _gender = v),
                    ),
                    const SizedBox(width: 12),
                    _GenderChip(
                      label: '保密',
                      value: 0,
                      groupValue: _gender,
                      onChanged: (v) => setState(() => _gender = v),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField('年龄', _ageController,
                    keyboardType: TextInputType.number),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              children: [
                const Text(
                  '标签',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._tags.map((tag) => Chip(
                          label: Text(tag),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => _removeTag(tag),
                          backgroundColor: const Color(0xFF12B7F5).withOpacity(0.1),
                          labelStyle: const TextStyle(
                            color: Color(0xFF12B7F5),
                          ),
                          deleteIconColor: const Color(0xFF12B7F5),
                        )),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _tagController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addTag(),
                        decoration: InputDecoration(
                          hintText: '+ 添加',
                          hintStyle: const TextStyle(
                            color: Color(0xFFC7C7CC),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F6F8),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              children: [
                const Text(
                  '横幅图片',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _pickImage(false),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E5EA)),
                    ),
                    child: _bannerPath != null && _bannerPath!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _bannerPath!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: Color(0xFF8A8A8E),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _isLoading ? null : _onSave,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF12B7F5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF12B7F5).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          '保存',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChanged;

  const _GenderChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF12B7F5).withOpacity(0.1)
              : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFF12B7F5) : const Color(0xFFE5E5EA),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF12B7F5) : const Color(0xFF8A8A8E),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
